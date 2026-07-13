# Flutter-Primeiro-Projeto
este é o 1º projeto depois da instalação e conf do Firebase
# link da documentação
https://firebase.google.com/docs/flutter/setup?hl=pt-br&platform=ios



# alguns plugIns para instalar caso ainda não tenha feito
flutter pub add cloud_firestore
flutter pub add firebase_auth
flutter pub add google_sign_in
flutter pub add firebase_messaging

# atualizando com CLI o projeto
dart pub global activate flutterfire_cli
flutterfire configure  
# Caso não  reconhecer
dart pub global list
dart pub global run flutterfire_cli:flutterfire configure
flutter run


# comando de atualizar o repositorio de downloads e limpar cache

flutter clean
flutter pub get
flutter run -d chrome