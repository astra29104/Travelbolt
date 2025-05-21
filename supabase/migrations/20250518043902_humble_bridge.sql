/*
  # Create Package Itinerary Table

  1. New Tables
    - package_itinerary
      - id (uuid, primary key)
      - package_id (uuid, foreign key)
      - no_of_days (integer)
      - description (text array)
      - created_at (timestamp)
      - updated_at (timestamp)
*/

CREATE TABLE IF NOT EXISTS package_itinerary (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  package_id uuid REFERENCES packages(id) ON DELETE CASCADE,
  no_of_days integer NOT NULL,
  description text[] NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_package_itinerary_package ON package_itinerary(package_id);

-- Add trigger for updating updated_at timestamp
CREATE TRIGGER update_package_itinerary_updated_at
  BEFORE UPDATE ON package_itinerary
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();