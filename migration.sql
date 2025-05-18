-- Migration file: create_travel_schema.sql

-- Enable uuid-ossp extension for UUID generation if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Table: users
CREATE TABLE public.users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  age INTEGER,
  location TEXT,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Table: destinations
CREATE TABLE public.destinations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Table: places
CREATE TABLE public.places (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  destination_id UUID NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT places_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE CASCADE
);

-- Table: destination_places
CREATE TABLE public.destination_places (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  destination_id UUID NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT destination_places_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE CASCADE
);

-- Table: guides
CREATE TABLE public.guides (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  destination_id UUID NOT NULL,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  experience_years INTEGER,
  languages TEXT[],
  rating NUMERIC,
  price_per_day NUMERIC,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT guides_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE SET NULL
);

-- Table: packages
CREATE TABLE public.packages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  destination_id UUID NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  duration INTEGER,
  price NUMERIC,
  main_image_url TEXT,
  rating NUMERIC,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT packages_destination_id_fkey FOREIGN KEY (destination_id) REFERENCES public.destinations(id) ON DELETE CASCADE
);

-- Table: package_itinerary
CREATE TABLE public.package_itinerary (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  package_id UUID NOT NULL,
  no_of_days INTEGER NOT NULL,
  description TEXT[],
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT package_itinerary_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id) ON DELETE CASCADE
);

-- Table: bookings
CREATE TABLE public.bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL,
  package_id UUID NOT NULL,
  guide_id UUID NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status TEXT,
  total_cost NUMERIC,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT bookings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE,
  CONSTRAINT bookings_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id) ON DELETE CASCADE,
  CONSTRAINT bookings_guide_id_fkey FOREIGN KEY (guide_id) REFERENCES public.guides(id) ON DELETE SET NULL
);
