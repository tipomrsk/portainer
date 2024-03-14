# [portainer.ads]()

Isso aqui, na real, é o início de um projeto de extensão da faculdade kkkk'
Então eu to aqui só pra começar o `DUMP` do que precisa pra funcionar.


## [Referência]()

- [Portainer](https://www.portainer.io/)
- [Docker](https://docs.docker.com/)


## [Deploy]()

Para fazer deploy do projeto, você pode rodar executar o docker-compose desse projeto, ou executar o stack-deploy.sh

```bash
  bash stack-deploy.sh 
```

>> Importante lembrar que o stack-deploy apaga as imagens, volumes, redes e etc que já existem do docker.



## [Documentação]()
```bash 
sudo bash docker-buid.sh
```

#### O pacote [`figlet`]() é pré-requisito pra ele rodar, o `stack-deploy.sh` já instala, caso não vá utilizar precisa instalar manualmente.

Esse script é interessante, eu acabei criando pra facilitar um pouco o build e push da imagem para as outras pessoas.
Ele é bem auto-explicativo, tem um guia bem fácil de ler e acompanhar **NÃO ESQUEÇA QUE É NECESSÁRIO USAR OS PATHS ABSOLUTOS** e é isso aí.

O script vai:
1. Logar no Docker Hub
2. Buildar a Imagem da aplicação.
3. Publicar a Imagem no Docker Hub.
4. Deslogar do Docker Hub.


## [Sobre o Portainer]()

Para fazer o deploy da sua aplicação no portainer, é importante criar uma imagem da sua aplicação. Por isso criei o `docker-build.sh`,

Dentro do Portainer, siga os seguintes passos:
1. Vá em Home.
2. Selecione o ambiente (normalmente o Local)
3. No menu, selecione a opção stack

### [Stack]()

Aqui é onde você vai fazer o deploy da sua aplicação, depois da imagem buildada e publicada é importante ajuste o seu docker compose para deployar a sua stack. Para ajudar a testar, ler e aprender, deixei nas referências um dos meus repositórios que é o [rastreio.com](https://github.com/tipomrsk/rastreio.com).

Aqui abaixo você pode ler um exemplo de um docker-compose.yml que eu uso para deployar a aplicação do rastreio.com no portainer.

Você pode usar o mesmo repositório para testar, ou ajustar para a sua aplicação.

```yml
version: "3.7"

volumes:
  app:

services:
  # API
  app:
    restart: always
    container_name: app
    command: bash /init-apache.sh
    image: tipomrsk/rastreio.com-apache:latest
    ports:
      - 9000:80
    depends_on:
      mysql:
        condition: service_healthy
  # MySQL
  mysql:
    image: mysql
    restart: always
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: cpfsearch
    ports:
      - 3306:3306
    healthcheck:
      test: [ "CMD", "mysqladmin" ,"ping", "-h", "localhost" ]
      timeout: 20s
      retries: 10
```
1. Vá para add stack
2. Dê o nome da sua stack
3. Você pode selecionar o método de build.
   1. **Web Editor**: Você pode colar o seu docker-compose.yml e fazer o deploy.
   2. **Upload File**: Você pode fazer o upload do seu docker-compose.yml e fazer o deploy.
   3. **Git Repository**: Você pode fazer o deploy do seu repositório do github.
   4. **Custom Template**: Você pode fazer o deploy de um template customizado criado no Portainer.
5. Lembre-se que será utilizado **SOMENTE O DOCKER-COMPOSE, TODO O RESTO DO REPOSITÓRIO, DIRETÓRIO OU ARQUIVO NÃO SERÁ UTILIZADO**.
6. Se necessário você pode adicionar variáveis de ambiente. 
7. Selecione um usuário ou time para gerenciar a stack.

Daqui pra frente, somente esse usuário ou grupo irá gerenciar a stack, então é importante que você selecione o usuário ou grupo correto.

## [Usuários e Times]()

Em settings, no menu lateral você verá as opções de usuários e times. 

### [Usuários]()
Aqui eu particularmente acho interessante colocar como username a matrícula do aluno. A senha sempre um hash aleatório por segurança. 

### [Times]()
Para o time, é interessante colocar o nome do projeto que será utilizado.
Depois é só selecionar o líder do projeto, e adicionar os alunos vinculados ao projeto para que possam gerenciar a stack.