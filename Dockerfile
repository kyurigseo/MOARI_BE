# MOARI 백엔드 이미지
# 경량 Alpine 리눅스 기반 Node.js 20
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

# 1) 의존성 먼저 설치 — package*.json이 안 바뀌면 이 레이어는 캐시를 재사용해 빌드가 빨라진다.
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# 2) 소스 복사 (.dockerignore에 적힌 파일은 제외)
COPY . .

# 3) 업로드 폴더를 미리 만들고, root가 아닌 node 사용자에게 권한을 준다.
RUN mkdir -p uploads/clubs && chown -R node:node /app/uploads

# 보안: root 대신 이미지에 기본 포함된 node 사용자로 실행
USER node

ENV PORT=3000
EXPOSE 3000

# 컨테이너 자체 헬스체크 — 1단계에서 만든 /health 사용
# localhost는 Alpine에서 IPv6(::1)로 먼저 해석되는데 서버는 IPv4(0.0.0.0)만 듣기 때문에 127.0.0.1을 쓴다.
HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- "http://127.0.0.1:${PORT}/health" || exit 1

CMD ["node", "server.js"]
