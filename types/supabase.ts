export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          name: string
          user_type: 'student' | 'manager'
          department: string | null
          roll_number: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          email: string
          name: string
          user_type: 'student' | 'manager'
          department?: string | null
          roll_number?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          name?: string
          user_type?: 'student' | 'manager'
          department?: string | null
          roll_number?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      events: {
        Row: {
          id: string
          name: string
          description: string | null
          date: string
          location: string
          club_name: string
          creator_id: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          description?: string | null
          date: string
          location: string
          club_name: string
          creator_id: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string | null
          date?: string
          location?: string
          club_name?: string
          creator_id?: string
          created_at?: string
          updated_at?: string
        }
      }
      od_requests: {
        Row: {
          id: string
          event_id: string
          student_id: string
          status: string
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          event_id: string
          student_id: string
          status?: string
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          event_id?: string
          student_id?: string
          status?: string
          created_at?: string
          updated_at?: string
        }
      }
      followers: {
        Row: {
          id: string
          student_id: string
          manager_id: string
          created_at: string
        }
        Insert: {
          id?: string
          student_id: string
          manager_id: string
          created_at?: string
        }
        Update: {
          id?: string
          student_id?: string
          manager_id?: string
          created_at?: string
        }
      }
      notifications: {
        Row: {
          id: string
          user_id: string
          title: string
          message: string
          read: boolean
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string
          title: string
          message: string
          read?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string
          message?: string
          read?: boolean
          created_at?: string
        }
      }
    }
  }
}