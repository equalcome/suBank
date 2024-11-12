-- name: CreateAccount :one
INSERT INTO accounts (
  owner,
  balance,
  currency
) VALUES (
  $1, $2, $3
)
RETURNING *;
  
-- name: GetAccount :one
SELECT * FROM accounts
WHERE id = $1 LIMIT 1;

-- name: GetAccountForUpdate :one
SELECT * FROM accounts
WHERE id = $1 LIMIT 1
FOR NO KEY UPDATE;

-- name: ListAccounts :many
SELECT * FROM accounts
WHERE owner = $1
ORDER BY id
LIMIT $2
OFFSET $3;

-- LIMIT $1：這表示最多返回 $1 行記錄，這裡的 $1 是一個佔位符，實際值在查詢執行時由使用者傳入。這讓查詢能夠靈活控制要返回的記錄數。

-- OFFSET $2：這表示從第 $2 行開始返回結果，這裡的 $2 也是一個佔位符。這通常用於實現分頁功能，可以跳過前面指定的行數。

-- LIMIT $1** 和 OFFSET $2： 這兩個佔位符可以用來實現查詢的分頁功能。舉例來說，LIMIT 10 和 OFFSET 20 將返回第 21 到第 30 條記錄，這使得查詢結果可以按頁分割和顯示。

-- name: UpdateAccount :one
UPDATE accounts 
SET balance = $2
WHERE id = $1
RETURNING *;

-- name: AddAccountBalance :one
UPDATE accounts 
SET balance = balance + sqlc.arg(amount)
WHERE id = sqlc.arg(id)
RETURNING *;

-- name: DeleteAccount :exec
DELETE FROM accounts 
WHERE id = $1;


