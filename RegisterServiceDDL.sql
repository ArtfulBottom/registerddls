CREATE EXTENSION "uuid-ossp";

-- Create product table code.
CREATE TABLE product (
  id uuid NOT NULL,
  lookupcode character varying(32) NOT NULL DEFAULT(''),
  count int NOT NULL DEFAULT(0),
  createdon timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT product_pkey PRIMARY KEY (id)
) WITH (
  OIDS=FALSE
);

CREATE INDEX ix_product_lookupcode
  ON product
  USING btree
  (lower(lookupcode::text) COLLATE pg_catalog."default");

INSERT INTO product VALUES (
       uuid_generate_v4()
     , 'lookupcode1'
     , 100
     , current_timestamp
);

INSERT INTO product VALUES (
       uuid_generate_v4()
     , 'lookupcode1'
     , 125
     , current_timestamp
);

INSERT INTO product VALUES (
       uuid_generate_v4()
     , 'lookupcode3'
     , 150
     , current_timestamp
);

-- Create employee table code.
CREATE TABLE employee (
  id uuid NOT NULL,
  employeeid character varying(32) NOT NULL DEFAULT(''),
  firstname character varying(128) NOT NULL DEFAULT(''),
  lastname character varying(128) NOT NULL DEFAULT(''),
  password character varying(512) NOT NULL DEFAULT(''),
  active boolean NOT NULL DEFAULT(FALSE), 
  classification int NOT NULL DEFAULT(0),
  managerid uuid NOT NULL,
  createdon timestamp without time zone NOT NULL DEFAULT now(),
  CONSTRAINT employee_pkey PRIMARY KEY (id)
) WITH (
  OIDS=FALSE
);

CREATE INDEX ix_employee_employeeid
  ON employee
  USING hash(employeeid);

-- Alter product table code.
alter table product add column price numeric(18, 4) default ((0));
alter table product alter column price set NOT NULL;

alter table product add column active boolean default (TRUE);
alter table product alter column active set NOT NULL;

-- Create transaction table code.

create table transaction (
       id uuid not null,
       cashierid uuid not null,
       totalamount numeric(20, 4) not null default((0)),
       classification int not null default(0),
       createdon timestamp without time zone not null default now(),
       referenceid uuid default null, 
       constraint pk_transaction_recordid primary key (id),
       constraint uk_transaction_cashierid unique(cashierid)
) with (
  oids=false
);

CREATE INDEX ix_transaction_cashierid
  ON transaction
  USING hash(cashierid);

-- Create transaction entry table code.
create table transaction_entry (
       id uuid not null,
       transactionid uuid not null,
       productid uuid not null,
       quantity int not null,
       unitprice numeric(18,4)[] not null, 
       constraint pk_transaction_entry_recordid primary key (id)
) with (
  oids=false
);

CREATE INDEX ix_transaction_entry_transactionid
  ON transaction_entry
  USING hash(transactionid);
