# College Events App - Supabase Configuration

This repository contains the Supabase configuration and database schema for the College Events App.

## Database Schema

### Tables

1. **users**
   - Stores user information for both students and managers
   - Includes fields: id, email, name, user_type, department, roll_number

2. **events**
   - Stores event information
   - Includes fields: id, name, description, date, location, club_name, creator_id

3. **od_requests**
   - Stores OD (On Duty) requests from students
   - Includes fields: id, event_id, student_id, status

4. **followers**
   - Tracks which students follow which event managers
   - Includes fields: id, student_id, manager_id

5. **notifications**
   - Stores notifications for users
   - Includes fields: id, user_id, title, message, read

## Row Level Security (RLS) Policies

All tables have RLS enabled with appropriate policies to ensure data security:

- Users can only view and update their own profiles
- Events are viewable by everyone but can only be created by managers
- Students can only view and create their own OD requests
- Managers can only view and update OD requests for their events
- Students can follow/unfollow managers
- Users can only view their own notifications

## Setup Instructions

1. Create a new Supabase project
2. Copy the SQL from `supabase/migrations/00_initial_schema.sql` and run it in the SQL editor
3. Copy your project URL and anon key
4. Create a `.env` file based on `.env.example` and add your Supabase credentials
5. Install the required dependencies in your React Native project:
   ```bash
   npx expo install @supabase/supabase-js @react-native-async-storage/async-storage react-native-url-polyfill
   ```

## Type Safety

The `types/supabase.ts` file contains TypeScript definitions for all database tables and their relationships. This ensures type safety when interacting with the Supabase client.

## Authentication

The app uses Supabase Auth with email/password authentication. Session management is handled automatically with AsyncStorage.

## Environment Variables

Make sure to set up the following environment variables in your `.env` file:

```
EXPO_PUBLIC_SUPABASE_URL=your-supabase-project-url
EXPO_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
```