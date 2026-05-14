-- ============================================================
-- MASTER ATTRIBUTES & EAV SCHEMA
-- ============================================================

-- 1. MASTER CATEGORY
CREATE TABLE master_category (
    category_id BIGSERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE,
    description VARCHAR(2000),
    status VARCHAR(50) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT
);

-- 2. MASTER SUBCATEGORY GROUPS
CREATE TABLE master_subcategorygroups (
    group_id BIGSERIAL PRIMARY KEY,
    category_id BIGINT NOT NULL REFERENCES master_category(category_id) ON DELETE CASCADE,
    group_name VARCHAR(255) NOT NULL,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT,
    UNIQUE (category_id, group_name)
);

-- 3. MASTER SUBCATEGORY (ATTRIBUTES)
CREATE TABLE master_subcategory (
    attribute_id BIGSERIAL PRIMARY KEY,
    group_id BIGINT NOT NULL REFERENCES master_subcategorygroups(group_id) ON DELETE CASCADE,
    attribute_name VARCHAR(500) NOT NULL,
    input_type VARCHAR(255) NOT NULL,
    dropdown_options JSONB,
    validation_rules JSONB,
    notes VARCHAR(2000),
    is_active BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT,
    UNIQUE (group_id, attribute_name)
);

-- ============================================================
-- ASSET LISTING & WORKFLOW SCHEMA
-- ============================================================

-- 4. ASSET NOTICE ESSENTIAL DETAILS
CREATE TABLE asset_notice_details (
    asset_id BIGSERIAL PRIMARY KEY,
    company_id BIGINT NOT NULL,
    branch_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL REFERENCES master_category(category_id),
    asset_title VARCHAR(500) NOT NULL,
    reserve_price DECIMAL(18, 2),
    
    -- Address & Location
    address_line1 VARCHAR(500),
    address_line2 VARCHAR(500),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(20),
    location_lat DECIMAL(10, 8),
    location_long DECIMAL(11, 8),

    -- Workflow Config & Status
    -- 1 = Single Approval (OTP), 2 = Maker-Checker
    approval_type INT DEFAULT 1 CHECK (approval_type IN (1, 2)),
    current_status VARCHAR(50) DEFAULT 'PENDING' 
        CHECK (current_status IN ('PENDING', 'SEND_FOR_APPROVAL', 'SEND_BACK_FOR_CORRECTION', 'APPROVED', 'CANCELLED', 'TRANSFERRED')),
    
    sale_status VARCHAR(50) DEFAULT 'DRAFTED' 
        CHECK (sale_status IN (
            'DRAFTED', 'LISTED_TO_PORTAL', 'AMENDMENT_IN_PROGRESS', 
            'AUCTION_CREATED', 'STARTED_BIDDING', 'SOLD_OUT', 'CANCELLED'
        )),
        
    -- Cancellation Flags
    is_cancellation_initiated BOOLEAN DEFAULT FALSE, -- Locks the asset from bidding if TRUE
    
    -- Buyer Analytics managed directly in this table
    buyer_interest_rating DECIMAL(3, 2) DEFAULT 0.00, -- e.g., 4.5 based on views/EMDs
    total_views INT DEFAULT 0,
    total_inquiries INT DEFAULT 0,
    
    is_active BOOLEAN DEFAULT TRUE,
    
    created_by BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. ASSET NOTICE ADDITIONAL DETAILS (JSONB)
CREATE TABLE asset_notice_additional_details (
    asset_id BIGINT PRIMARY KEY REFERENCES asset_notice_details(asset_id) ON DELETE CASCADE,
    
    -- Stores all 2100+ attributes in a single JSONB column
    -- Format: {"8": {"name": "Property Name", "value": "Patel sons"}, "25": {"name": "BHK Configuration", "value": "2_BHK"}}
    attribute_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    
    -- Optional: Maintain search tokens or flattened data for specific high-frequency filters
    search_tokens TSVECTOR,
    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for ultra-fast JSON querying
CREATE INDEX idx_asset_attributes_gin ON asset_notice_additional_details USING GIN (attribute_data);

-- 6. ASSET MEDIA (IMAGES & VIDEOS)
CREATE TABLE asset_media (
    media_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL REFERENCES asset_notice_details(asset_id) ON DELETE CASCADE,
    file_type VARCHAR(20) CHECK (file_type IN ('IMAGE', 'VIDEO')),
    file_path TEXT NOT NULL,
    file_name VARCHAR(255),
    revised_file_name VARCHAR(255),
    is_main_image BOOLEAN DEFAULT FALSE,
    file_metadata JSONB, -- Includes IP, dimensions, etc.
    
    status VARCHAR(50) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'DELETED', 'APPROVED', 'CANCELLED', 'REMOVED_BY_SYSTEM')),
    is_active BOOLEAN DEFAULT TRUE,    
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. ASSET DOCUMENTS
CREATE TABLE asset_documents (
    doc_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL REFERENCES asset_notice_details(asset_id) ON DELETE CASCADE,
    file_path TEXT NOT NULL,
    file_name VARCHAR(255),
    revised_file_name VARCHAR(255),
    file_metadata JSONB,
    
    status VARCHAR(50) DEFAULT 'PENDING' 
        CHECK (status IN ('PENDING', 'DELETED', 'APPROVED', 'CANCELLED', 'REMOVED_BY_SYSTEM')),
    is_active BOOLEAN DEFAULT TRUE,
    
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. ASSET WORKFLOW HISTORY (Audit Trail)
-- Tracks: Approval, Amendment Approval, Cancel, Transfer
CREATE TABLE asset_workflow (
    history_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL REFERENCES asset_notice_details(asset_id),
    workflow_type VARCHAR(50) CHECK (workflow_type IN ('CREATION', 'APPROVAL', 'AMENDMENT', 'CANCELLATION', 'TRANSFER')),
    action VARCHAR(50) CHECK (action IN ('SEND_FOR_APPROVAL', 'SEND_BACK_FOR_CORRECTION', 'APPROVED', 'REJECTED')),
    sender_id BIGINT,
    receiver_id BIGINT,
    remarks TEXT,
    otp_verified BOOLEAN DEFAULT FALSE, -- For single approval workflow
    client_ip VARCHAR(50),
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. ASSET AMENDMENT REQUESTS (Header)
CREATE TABLE asset_amendment_requests (
    request_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL REFERENCES asset_notice_details(asset_id),
    amendment_number INT NOT NULL,
    amendment_reason TEXT NOT NULL,    
    status VARCHAR(50) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SENT_FOR_APPROVAL', 'APPROVED', 'REJECTED', 'CANCELLED')),
    remarks TEXT,
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by BIGINT,
    approved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (asset_id, amendment_number)
);

-- 10. ASSET AMENDMENT DETAILS (Staging & Delta for JSONB)
CREATE TABLE asset_amendment_details (
    request_id BIGINT PRIMARY KEY REFERENCES asset_amendment_requests(request_id) ON DELETE CASCADE,
    
    -- Changes to essential fields (asset_notice_details)
    -- E.g. {"asset_title": {"old": "Old Name", "new": "New Name"}}
    essential_changes JSONB,
    
    -- Changes to additional details (asset_notice_additional_details)
    -- This handles your specific Added, Updated, Removed scenarios
    -- E.g. {"updated": {"25": {"name": "BHK Configuration", "old": "1_BHK", "new": "2_BHK"}}}
    additional_changes JSONB,
    
    -- The fully merged proposed JSONB state (easy to copy to main table on approval)
    proposed_attribute_data JSONB,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. ASSET AMENDMENT MEDIA (Tracking Actions)
CREATE TABLE asset_amendment_media (
    id BIGSERIAL PRIMARY KEY,
    request_id BIGINT NOT NULL REFERENCES asset_amendment_requests(request_id) ON DELETE CASCADE,
    media_id BIGINT NOT NULL REFERENCES asset_media(media_id),
    action VARCHAR(20) CHECK (action IN ('ADD', 'DELETE', 'REPLACE')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. ASSET AMENDMENT DOCUMENTS (Tracking Actions)
CREATE TABLE asset_amendment_documents (
    id BIGSERIAL PRIMARY KEY,
    request_id BIGINT NOT NULL REFERENCES asset_amendment_requests(request_id) ON DELETE CASCADE,
    doc_id BIGINT NOT NULL REFERENCES asset_documents(doc_id),
    action VARCHAR(20) CHECK (action IN ('ADD', 'DELETE', 'REPLACE')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

-- 10. OPTIMIZED MAIN IMAGES (For Home Page Display)
-- Stores compressed/web-optimized versions of main images
CREATE TABLE asset_main_image (
    mainimage_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL REFERENCES asset_notice_details(asset_id) ON DELETE CASCADE,
    original_media_id BIGINT NOT NULL REFERENCES asset_media(media_id),
    file_path TEXT NOT NULL,
    file_name VARCHAR(255),
    width INT,
    height INT,
    file_size_bytes BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (asset_id) -- Only one optimized main image per asset
);

CREATE TABLE asset_cancellation_history (
    id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL REFERENCES asset_notice_details(asset_id) ON DELETE CASCADE,
    
    action VARCHAR(100) NOT NULL, -- e.g., 'CANCELLATION_INITIATED', 'REMOVED_CANCELLATION_REQUEST', 'APPROVED_CANCELLATION_REQUEST'
    reason TEXT,
    remarks TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- BUYER ENGAGEMENT & ANALYTICS
-- ============================================================

-- 14. ASSET USER VIEWS
-- Tracks every time a user views an asset on the portal
CREATE TABLE asset_user_views (
    view_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL REFERENCES asset_notice_details(asset_id) ON DELETE CASCADE,
    user_id BIGINT, -- Can be NULL for guest users
    ip_address VARCHAR(45),
    user_agent TEXT,
    device_type VARCHAR(50), -- MOBILE, DESKTOP, TABLET
    viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_asset_views ON asset_user_views(asset_id, viewed_at);
CREATE INDEX idx_user_views ON asset_user_views(user_id) WHERE user_id IS NOT NULL;

-- 15. ASSET USER INQUIRIES
-- Tracks leads and questions submitted by interested buyers
CREATE TABLE asset_user_inquiries (
    inquiry_id BIGSERIAL PRIMARY KEY,
    asset_id BIGINT NOT NULL REFERENCES asset_notice_details(asset_id) ON DELETE CASCADE,
    user_id BIGINT, -- Authenticated user making the inquiry
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    inquiry_type VARCHAR(50) DEFAULT 'GENERAL' CHECK (inquiry_type IN ('GENERAL', 'SITE_VISIT_REQUEST', 'DOCUMENT_REQUEST', 'CALLBACK_REQUEST')),
    status VARCHAR(50) DEFAULT 'NEW' CHECK (status IN ('NEW', 'CONTACTED', 'RESOLVED', 'CLOSED_NO_RESPONSE')),
    remarks TEXT,
    user_ip VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_asset_inquiries ON asset_user_inquiries(asset_id, status);
CREATE INDEX idx_assigned_inquiries ON asset_user_inquiries(assigned_to, status);

