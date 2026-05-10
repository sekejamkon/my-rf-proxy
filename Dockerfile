FROM debian:bookworm-slim

COPY install.sh /app/install.sh
COPY config.json /etc/config.json

WORKDIR /app

# Install dependencies with clear output
RUN echo "📦 Installing system dependencies..." && \
    apt-get update && apt-get install -y --no-install-recommends \
    bash git curl wget unzip tzdata openssl ca-certificates \
    && echo "✅ Dependencies installed successfully" \
    && rm -rf /var/lib/apt/lists/*

# Setup and configure xray
RUN echo "⚙️  Running installation script..." && \
    chmod +x /app/install.sh && /app/install.sh && \
    echo "✅ Installation completed successfully"

# Create startup message adapted for Runflare
RUN echo '#!/bin/bash' > /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "╔════════════════════════════════════════════════════════════╗"' >> /app/startup.sh && \
    echo 'echo "║          🚀 G2RAY - RUNFLARE SERVICE INITIALIZED 🚀        ║"' >> /app/startup.sh && \
    echo 'echo "╚════════════════════════════════════════════════════════════╝"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "📋 Configuration:"' >> /app/startup.sh && \
    echo 'echo "   • Config File: /etc/config.json"' >> /app/startup.sh && \
    echo 'echo "   • Internal Port: 80"' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'echo "✨ Service is running and ready to accept connections..."' >> /app/startup.sh && \
    echo 'echo ""' >> /app/startup.sh && \
    echo 'exec /usr/local/bin/xray -c /etc/config.json' >> /app/startup.sh && \
    chmod +x /app/startup.sh

# Expose port 80 for Runflare's reverse proxy
EXPOSE 80

CMD ["/app/startup.sh"]
