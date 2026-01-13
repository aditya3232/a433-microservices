# Gunakan Node.js LTS berbasis Alpine (ringan)
FROM node:18-alpine

# Set working directory di dalam container
WORKDIR /usr/src/app

# Copy file dependency terlebih dahulu (best practice Docker layer cache)
COPY package*.json ./

# Install dependency
RUN npm install --production

# Copy seluruh source code
COPY . .

# Expose port (sesuai dengan process.env.PORT)
EXPOSE 3000

# Jalankan aplikasi
CMD ["node", "index.js"]
