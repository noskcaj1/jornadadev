from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen
import json
import re


HOST = "0.0.0.0"
PORT = 8080


class CepHandler(BaseHTTPRequestHandler):

    def enviar_resposta(self, status: int, conteudo: str) -> None:
        dados = conteudo.encode("utf-8")

        self.send_response(status)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(dados)))
        self.end_headers()

        self.wfile.write(dados)

    def do_GET(self) -> None:

        match = re.fullmatch(r"/cep/(\d{8})", self.path)

        if not match:
            self.enviar_resposta(
                400,
                "ERRO|Informe o CEP no formato /cep/18035000"
            )
            return

        cep = match.group(1)
        url = f"https://viacep.com.br/ws/{cep}/json/"

        try:
            requisicao = Request(
                url,
                headers={"User-Agent": "Protheus-MP8-CEP-Proxy/1.0"}
            )

            with urlopen(requisicao, timeout=15) as resposta:
                dados = json.loads(resposta.read().decode("utf-8"))

            if dados.get("erro"):
                self.enviar_resposta(404, "ERRO|CEP nao encontrado")
                return

            logradouro = dados.get("logradouro", "")
            bairro = dados.get("bairro", "")
            cidade = dados.get("localidade", "")
            uf = dados.get("uf", "")
            ibge = dados.get("ibge", "")

            # Formato simples para facilitar a leitura pelo MP8.
            resultado = (
                f"OK|"
                f"{logradouro}|"
                f"{bairro}|"
                f"{cidade}|"
                f"{uf}|"
                f"{ibge}"
            )

            self.enviar_resposta(200, resultado)

        except HTTPError as erro:
            self.enviar_resposta(
                502,
                f"ERRO|ViaCEP retornou HTTP {erro.code}"
            )

        except URLError as erro:
            self.enviar_resposta(
                502,
                f"ERRO|Falha de conexao: {erro.reason}"
            )

        except Exception as erro:
            self.enviar_resposta(
                500,
                f"ERRO|Falha interna: {erro}"
            )

    def log_message(self, formato: str, *args) -> None:
        print(f"{self.client_address[0]} - {formato % args}")


if __name__ == "__main__":
    servidor = HTTPServer((HOST, PORT), CepHandler)

    print(f"Servidor de CEP iniciado em http://127.0.0.1:{PORT}")
    print("Exemplo: http://127.0.0.1:8080/cep/18035000")

    try:
        servidor.serve_forever()
    except KeyboardInterrupt:
        print("\nServidor encerrado.")
        servidor.server_close()