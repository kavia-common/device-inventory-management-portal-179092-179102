-- Inventory database schema for PostgreSQL

-- Ensure extension for useful functions (safe to run if already exists)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Main inventory_items table
CREATE TABLE IF NOT EXISTS public.inventory_items (
    id SERIAL PRIMARY KEY,
    asset_tag TEXT UNIQUE NOT NULL,
    type TEXT,
    brand TEXT,
    model TEXT,
    serial_number TEXT,
    status TEXT,
    assigned_to TEXT,
    location TEXT,
    purchase_date DATE,
    warranty_expiry DATE,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indexes to improve query performance
CREATE INDEX IF NOT EXISTS idx_inventory_items_type ON public.inventory_items (type);
CREATE INDEX IF NOT EXISTS idx_inventory_items_status ON public.inventory_items (status);
CREATE INDEX IF NOT EXISTS idx_inventory_items_assigned_to ON public.inventory_items (assigned_to);

-- Trigger function to auto-update updated_at timestamp on row updates
CREATE OR REPLACE FUNCTION public.set_updated_at_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update updated_at before each UPDATE
DROP TRIGGER IF EXISTS trg_inventory_items_updated_at ON public.inventory_items;
CREATE TRIGGER trg_inventory_items_updated_at
BEFORE UPDATE ON public.inventory_items
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at_timestamp();
