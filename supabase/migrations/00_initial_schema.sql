-- Enable the necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create enum for user types
CREATE TYPE user_type AS ENUM ('student', 'manager');

-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  user_type user_type NOT NULL,
  department TEXT,
  roll_number TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create events table
CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  date TIMESTAMPTZ NOT NULL,
  location TEXT NOT NULL,
  club_name TEXT NOT NULL,
  creator_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create od_requests table
CREATE TABLE od_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID NOT NULL REFERENCES events(id),
  student_id UUID NOT NULL REFERENCES users(id),
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(event_id, student_id)
);

-- Create followers table
CREATE TABLE followers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  student_id UUID NOT NULL REFERENCES users(id),
  manager_id UUID NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(student_id, manager_id)
);

-- Create notifications table
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add RLS policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE od_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE followers ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view their own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- Events policies
CREATE POLICY "Events are viewable by everyone"
  ON events FOR SELECT
  USING (true);

CREATE POLICY "Event managers can create events"
  ON events FOR INSERT
  WITH CHECK (auth.uid() = creator_id AND EXISTS (
    SELECT 1 FROM users
    WHERE id = auth.uid() AND user_type = 'manager'
  ));

-- OD requests policies
CREATE POLICY "Students can view their own OD requests"
  ON od_requests FOR SELECT
  USING (auth.uid() = student_id);

CREATE POLICY "Managers can view OD requests for their events"
  ON od_requests FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM events
    WHERE events.id = od_requests.event_id
    AND events.creator_id = auth.uid()
  ));

CREATE POLICY "Students can create OD requests"
  ON od_requests FOR INSERT
  WITH CHECK (auth.uid() = student_id);

CREATE POLICY "Managers can update OD request status"
  ON od_requests FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM events
    WHERE events.id = od_requests.event_id
    AND events.creator_id = auth.uid()
  ));

-- Followers policies
CREATE POLICY "Anyone can view followers"
  ON followers FOR SELECT
  USING (true);

CREATE POLICY "Students can follow/unfollow managers"
  ON followers FOR INSERT
  WITH CHECK (auth.uid() = student_id AND EXISTS (
    SELECT 1 FROM users
    WHERE id = manager_id AND user_type = 'manager'
  ));

-- Notifications policies
CREATE POLICY "Users can view their own notifications"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

-- Create triggers for updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_events_updated_at
  BEFORE UPDATE ON events
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_od_requests_updated_at
  BEFORE UPDATE ON od_requests
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();