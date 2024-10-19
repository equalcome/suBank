# 啟動 PostgreSQL 的 Docker 容器，名稱為 postgres12
postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

# 創建 simple_bank 資料庫
createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

# 刪除 simple_bank 資料庫
dropdb:
	docker exec -it postgres12 dropdb simple_bank

# 執行資料庫的升級遷移，使資料庫達到最新狀態
migrateup:
	migrate -path /mnt/c/Users/User/Desktop/suBank/simplebank/db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose up

# 執行資料庫的降級遷移，撤回最新的遷移
migratedown:
	migrate -path /mnt/c/Users/User/Desktop/suBank/simplebank/db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose down

# 使用 sqlc 生成 SQL 查詢代碼
sqlc:
	sqlc generate

# 執行所有測試，顯示詳細的輸出並計算覆蓋率
test: 
	go test -v -cover ./...


.PHONY: postgres createdb dropdb migrateup migratedown sqlc test
