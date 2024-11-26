# 啟動 PostgreSQL 的 Docker 容器，名稱為 postgres12
postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

# 創建 simple_bank 資料庫
createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

# 刪除 simple_bank 資料庫
dropdb:
	docker exec -it postgres12 dropdb simple_bank

# 執行資料庫的升級遷移，使資料庫達到最新狀態
migrateup:
	migrate -path ./db/migration -database "postgresql://root:ewNWJ2nBQxCqyFeoCFDW@simple-bamk.chwmuq88opg2.ap-northeast-1.rds.amazonaws.com:5432/simple_bank" --verbose up
migrateup1:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose up 1

# 執行資料庫的降級遷移，撤回最新的遷移
migratedown:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose down

migratedown1:
	migrate -path ./db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" --verbose down 1



# 使用 sqlc 生成 SQL 查詢代碼
sqlc:
	sqlc generate

# 執行所有測試，顯示詳細的輸出並計算覆蓋率
test: 
	go test -v -cover ./...

server:
	go run main.go

mock:
	 mockgen -package mockdb -destination db/mock/store.go github.com/techschool/simplebank/db/sqlc Store


.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock 
