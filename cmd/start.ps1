# 设置退出时的清理操作
$ErrorActionPreference = "Stop"
try {
    # 编译 Go 程序
    & go build -o server

    # 启动多个服务实例 (在后台运行)
    Start-Process -NoNewWindow -FilePath "./server" -ArgumentList "-port=8001"
    Start-Process -NoNewWindow -FilePath "./server" -ArgumentList "-port=8002"
    Start-Process -NoNewWindow -FilePath "./server" -ArgumentList "-port=8003 -api=1"

    # 暂停 2 秒，确保服务器启动
    Start-Sleep -Seconds 2

    # 输出测试开始提示
    Write-Host ">>> start test"

    # 发送并发的 HTTP 请求
    Start-Job { Invoke-WebRequest "http://localhost:9999/api?key=Tom" }
    Start-Job { Invoke-WebRequest "http://localhost:9999/api?key=Tom" }
    Start-Job { Invoke-WebRequest "http://localhost:9999/api?key=Tom" }
    Start-Job { Invoke-WebRequest "http://localhost:9999/api?key=Tom" }
    Start-Job { Invoke-WebRequest "http://localhost:9999/api?key=Tom" }
    Start-Job { Invoke-WebRequest "http://localhost:9999/api?key=Tom" }
	

    # 等待所有后台任务完成
    Get-Job | Wait-Job | Out-Null

} finally {
    # 清理操作：终止所有 server 进程并删除文件
    Get-Process server -ErrorAction SilentlyContinue | ForEach-Object { $_.Kill() }
    Remove-Item -Force "./server" -ErrorAction SilentlyContinue
}
