INSERT INTO transaction_attributes VALUES (2, 'Kledij');
INSERT INTO transaction_attributes VALUES (3, 'Voeding');

-- - Loon Lorenzo
INSERT INTO transactions VALUES (1, 1, 1, 1, 'Loon', '05-JAN-2009', '01-JAN-2009', 0);
INSERT INTO transaction_details VALUES (1, 1, 1, 1543.06);

-- - Loon Tineke
INSERT INTO transactions VALUES (2, 1, 2, 2, 'Loon', '06-JAN-2009', '01-JAN-2009', 0);
INSERT INTO transaction_details VALUES (2, 2, 2, 1643.06);

-- - uitgave colruyt
INSERT INTO transactions VALUES (3, 2, 3, 1, 'Colruyt', '11-JAN-2009', '06-JAN-2009', 0);
INSERT INTO transaction_details VALUES (3, 3, 2, 60);
INSERT INTO transaction_details VALUES (4, 3, 1, 41.07);
INSERT INTO transactions_transaction_attributes VALUES (3, 3);