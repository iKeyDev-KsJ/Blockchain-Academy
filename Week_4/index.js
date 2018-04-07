const express = require('express')      // express 모듈 로딩
const app = express()                   // 선언

app.use(express.static('public'))       // public 정적 파일 서비스 제공
app.listen(3000)                        // http://localhost:3000 으로 웹서버 시작