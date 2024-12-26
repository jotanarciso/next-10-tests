# Estágio de build
FROM node:18-alpine AS builder

WORKDIR /app

# Copiar arquivos de configuração
COPY package*.json ./
COPY next.config.mjs ./
COPY jsconfig.json ./
COPY tailwind.config.js ./
COPY postcss.config.mjs ./

# Instalar dependências
RUN npm ci

# Copiar código fonte
COPY src ./src
COPY public ./public

# Build da aplicação
RUN npm run build

# Estágio de produção
FROM node:18-alpine AS runner

WORKDIR /app

# Criar usuário não-root
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copiar arquivos necessários
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# Configurar permissões
RUN chown -R nextjs:nodejs /app

# Mudar para usuário não-root
USER nextjs

# Expor porta
EXPOSE 3000

# Variáveis de ambiente
ENV PORT 3000
ENV NODE_ENV production
ENV HOSTNAME "0.0.0.0"

# Comando para iniciar a aplicação Next.js
CMD ["npm", "start"] 