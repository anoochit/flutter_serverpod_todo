--
-- Class Todo as table todos
--

CREATE TABLE "todos" (
  "id" serial,
  "title" text NOT NULL,
  "isCompleted" boolean NOT NULL,
  "createdAt" timestamp without time zone NOT NULL,
  "userId" integer NOT NULL
);

ALTER TABLE ONLY "todos"
  ADD CONSTRAINT todos_pkey PRIMARY KEY (id);


