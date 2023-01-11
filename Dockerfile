FROM nginx:latest

EXPOSE 80
USER root

RUN apt-get update && apt-get install -y supervisor wget unzip

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
ENV UUID 7b02f09b-9305-4f33-80ab-c2e040bd1762
ENV VMESS_WSPATH /7b02f09b-9305-4f33-80ab-c2e040bd1762-vmess
ENV VLESS_WSPATH /7b02f09b-9305-4f33-80ab-c2e040bd1762-vless

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir /etc/v2ray /usr/local/v2ray
COPY config.json /etc/v2ray/
COPY entrypoint.sh /usr/local/v2ray/


RUN wget -q -O /tmp/v2ray-linux-64.zip https://github.com/v2fly/v2ray-core/releases/download/v5.1.0/v2ray-linux-64.zip && \
    unzip -d /usr/local/v2ray /tmp/v2ray-linux-64.zip && \
    chmod a+x /usr/local/v2ray/entrypoint.sh

ENTRYPOINT [ "/usr/local/v2ray/entrypoint.sh" ]
CMD ["/usr/bin/supervisord"]
