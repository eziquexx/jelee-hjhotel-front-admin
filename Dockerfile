# Node.js 이미지를 사용하여 React 앱을 빌드
FROM node:20 AS build

# 작업 디렉토리 설정
WORKDIR /app

# package.json과 package-lock.json 먼저 복사 (캐시 무효화)
COPY package*.json ./

# 의존성 설치
RUN npm install

# 소스 코드 전체 복사
COPY . .

# React 앱 빌드
RUN npm run build

# Nginx 이미지를 사용하여 앱을 서빙
FROM nginx

# Nginx 설정 파일을 덮어쓰기
COPY nginx.conf /etc/nginx/nginx.conf

# 빌드된 React 앱을 Nginx의 기본 HTML 디렉토리로 복사
COPY --from=build /app/build /usr/share/nginx/html

# 80 포트 노출
EXPOSE 80

# Nginx 서버 실행
CMD ["nginx", "-g", "daemon off;"]