CREATE TABLE my_btree_table
(
    id   INT PRIMARY KEY,
    name VARCHAR(50) UNIQUE
);

CREATE TABLE my_fulltext_table
(
    id      INT PRIMARY KEY,
    content TEXT,
    FULLTEXT (content)
);

CREATE TABLE my_spatail_table
(
    id       INT PRIMARY KEY,
    location POINT not null,
    SPATIAL INDEX (location)
);