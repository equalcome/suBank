// api/random_user_test_helpers.go
package api

import (
	"testing"

	"github.com/stretchr/testify/require"
	db "github.com/techschool/simplebank/db/sqlc"
	"github.com/techschool/simplebank/util"
)

// randomUser 創建一個隨機的測試用戶，返回用戶資料和原始密碼
func randomUser(t *testing.T) (user db.User, password string) {
	password = util.RandomString(6) // 生成隨機密碼
	hashedPassword, err := util.HashPassword(password) // 將密碼進行哈希處理
	require.NoError(t, err) // 確保哈希處理不會出錯

	user = db.User{
		Username:       util.RandomOwner(),
		HashedPassword: hashedPassword,
		FullName:       util.RandomOwner(),
		Email:          util.RandomEmail(),
	}
	return
}
