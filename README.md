# android-backdoor

#Introdução
O repositório “android-backdoor” não é um projeto e sim um procedimento do qual utiliza ferramentas já existentes de código aberto com o objetivo de auxiliar na recuperação de dispositivos furtados, roubados ou até mesmo perdidos. Tal procedimento tem como objetivo a implementação de um servidor SSH em aparelhos celulares que possuem o sistema ANDROID, mas com algumas peculiaridades que podem definir o procedimento como a criação de uma “porta dos fundos” ou um antifurto que entrega o total controle do dispositivo ao seu dono de forma transparente e segura.
As peculiaridades nesse procedimento são:
- Supera “HardResets”: O “antifurto” permanecerá mesmo com a restauração de fábrica dos aparelhos, salvo de algumas ROM's customizadas;
- Acesso SUPERUSUARIO: Também conhecido como ROOT, o superusuário possui o maior nível de privilégios, com isso é possível controlar remotamente qualquer função do dispositivo;
- Possibilidade de instalação e desinstalação de qualquer aplicativo através do ADB ou diretamente no console através do comando "pm";
- Conexão Reversa: Quando um dispositivo está conectado na internet através da rede móvel, a conexão direta pode ser realizada sem problemas, mas quando o dispositivo utiliza WIFI, está sobre NAT, nesse caso a conexão direta não é possível, então surge a funcionalidade da conexão reversa;
- Transparência: Como esse procedimento em questão utiliza de ferramentas de código aberto é possível verificar tudo o que está sendo executado de forma transparente;
- Segurança: Conexão SSH utilizando de chaves para autenticação, uma das formas mais seguras de comunicação amplamente utilizada seja pequenas até grandes corporações para o gerenciamento dos servidores;

#Motivação
O volume de furtos/roubos de aparelhos celulares no Brasil é preocupante, não há uma forma eficaz de segurança, os fabricantes não investem nisso e o bloqueio de IMEI não é uma forma eficaz para recuperar o aparelho ou até mesmo coibir o furto ou roubo. Logo dou minha pequena contribuição, quem estiver dispositivo a auxiliar nesse repositório, que fique à vontade, toda ajuda é bem-vinda, principalmente na questão da simplificação de propagação do conhecimento, até para que pessoas que não tenham domínio em sistemas LINUX, compiladores, programação, ou até mesmo o GIT, sejam capazes de realizar tal procedimento.

#Procedimento
O procedimento para a instalação do "android-backdoor" no seu aparelho é dividido em dois itens, são eles:
- Instalação;
- Configuração;

Instalação

O procedimento de instalação é simples e é realizado através de OTA (mais informações nas referências). É necessário realizar o download de um arquivo chamado update.zip esse arquivo deve ser armazenado preferivelmente na raiz do seu cartão de memória, ou seja, fora de qualquer “pasta”, logo deve reiniciar o aparelho no recovery mode e aplicar o arquivo anteriormente citado.

Para acessar o recovery mode basta, desligar seu aparelho e realizar uma combinação especial de teclas ao iniciar, essa combinação varia para cada aparelho (verificar nas referências), mas geralmente a combinação é “aumentar volume + home + botão ligar”, manter pressionado, por alguns instantes, logo, soltar. Com o recovery mode iniciado navegue usando as teclas de aumentar e diminuir o volume e o botão “power” para acessar, salientando novamente, que essas opções variam de cada aparelho, selecione uma opção chamada “apply update from sdcard”, com isso será exibido uma lista de arquivos do seu cartão de memória, você precisa selecionar o update.zip do qual foi baixado anteriormente.

Caso tenha sucesso nessa etapa, está pronto para iniciar o procedimento de configuração, caso tenha dado erro como “signature verification failed” seu OTA está bloqueado para esse tipo de instalação, geralmente os fabricantes realizam isso, para resolver esse problema é necessário certo conhecimento e ter ROOT no aparelho. Para desbloquear o OTA temporariamente, você precisa mover o arquivo /system/etc/security/otacerts.zip para outro diretório qualquer (recomendado salvar no cartão de memória por exemplo) desligar e realizar o procedimento de instalação anteriormente citado, após isso, restaurar o arquivo novamente. Vale salientar que, o ponto de montagem /system, dependendo do aparelho, é somente leitura, você precisa “remountar” ele com permissões de escrita, para isso tenha o busybox e use o comando busybox mount -o remount,rw /system. Novamente é importante destacar que para resolver esse problema você precisa ter conhecimentos no assunto, se não tiver conhecimentos não o realize, se mesmo assim quiser fazer tenha cuidado, pois, você pode danificar seu aparelho.

Configuração

O procedimento de configuração é um pouco mais complexo em relação ao procedimento de instalação, mas mesmo assim ainda é simples, até mesmo para usuários leigos.
Após o procedimento de instalação (anteriormente citado) seu aparelho aguardará a configuração, haverão dois arquivos que devem ser editados e salvos apenas quando a configuração estiver pronta, são eles:
- /sdcard/android-backdoor/hosts.txt
- /sdcard/android-backdoor/reverse_port.txt

No arquivo “hosts.txt” devem ser inseridos os endereços que o dispositivo conectará para “entregar o acesso” podem ser inseridos quantos desejar, é recomendado inserir um domínio dinâmico, caso você tenha o endereço de IP dinâmico, existem muitos gratuitos inclusive, você pode inserir o endereço de seu servidor, caso possua. Considerando que você tenha o seu domínio dinâmico “apontando” para o endereço de IP do seu computador, você colocará no arquivo “hosts.txt” o conteúdo de exemplo: “meuhostdinamico.dominiodinamico.com”, mais informações sobre os domínios dinâmicos nas referências.

No arquivo “reverse_port.txt” é inserido a porta de conexão reversa que o aparelho criará no momento da conexão, é recomendado inserir uma porta maior que 1024 e menor que 65535, cada dispositivo deve possuir sua própria.

Após editados e configurados os arquivos, seu aparelho irá gerar os certificados de criptografia de trafego, de conexão ao aparelho e de conexão reversa a seu computador ou servidor SSH, feito isso o aparelho reiniciará automaticamente.


Funcionamento

Após o procedimento concluído você terá chaves de acesso (admin_id_rsa.pub e android_id_rsa) armazenadas no seu cartão de memória em um diretório chamado “android-backdoor”, vale ressaltar que não devem ser mantidas nesse local e após todo o procedimento concluído, remover esse diretório.

A chave “admin_id_rsa.pub” é uma chave publica, e é utilizada quando o aparelho realiza o login reverso no seu servidor SSH no momento da “entrega do acesso”, no seu computador ou seu servidor, por exemplo.

A chave “android_id_rsa” é uma chave privada e é utilizada para realizar o login no aparelho.

Conexão reversa: desempenhando um papel importante a conexão reversa “entrega o acesso” do seu dispositivo para o computador cadastrado no arquivo “hosts.txt”, além disso é importante na notificação, sem isso, você não terá o contato com o aparelho, caso o perca.

Quando o aparelho se conecta no computador cadastrado, o computador “ouvirá” uma conexão de acesso na porta cadastrada no arquivo “reverse_port.txt”, essa porta direciona para o servidor SSH do aparelho, então para acessar seu aparelho, basta se conectar nessa porta com um cliente SSH e usando o certificado “android_id_rsa” para a autenticação, você terá todos os privilégios, todos os comandos, qualquer coisa que queira fazer no aparelho e remotamente de forma transparente.

# Referências
- OTA

https://source.android.com/devices/tech/ota/

- Acessar recovery mode

http://forum.xda-developers.com/wiki/Recovery

- DDNS Dominios dinamicos

https://en.wikipedia.org/wiki/Dynamic_DNS
