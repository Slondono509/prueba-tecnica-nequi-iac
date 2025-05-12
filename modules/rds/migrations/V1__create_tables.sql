-- Tabla de Franquicias
CREATE TABLE franchises (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Sucursales
CREATE TABLE branches (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    franchise_id BIGINT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_franchise
        FOREIGN KEY (franchise_id)
        REFERENCES franchises(id)
        ON DELETE CASCADE
);

-- Tabla de Productos
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    branch_id BIGINT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_branch
        FOREIGN KEY (branch_id)
        REFERENCES branches(id)
        ON DELETE CASCADE
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_branches_franchise_id ON branches(franchise_id);
CREATE INDEX idx_products_branch_id ON products(branch_id);
CREATE INDEX idx_products_stock ON products(stock);

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_franchises_updated_at
    BEFORE UPDATE ON franchises
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_branches_updated_at
    BEFORE UPDATE ON branches
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at
    BEFORE UPDATE ON products
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 