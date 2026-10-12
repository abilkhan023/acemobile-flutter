import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @hi.
  ///
  /// In ru, this message translates to:
  /// **'Привет'**
  String get hi;

  /// No description provided for @welcome.
  ///
  /// In ru, this message translates to:
  /// **'Добро пожаловать!'**
  String get welcome;

  /// No description provided for @clubs.
  ///
  /// In ru, this message translates to:
  /// **'Клубы'**
  String get clubs;

  /// No description provided for @club.
  ///
  /// In ru, this message translates to:
  /// **'Клуб'**
  String get club;

  /// No description provided for @locations.
  ///
  /// In ru, this message translates to:
  /// **'Локации'**
  String get locations;

  /// No description provided for @balance.
  ///
  /// In ru, this message translates to:
  /// **'Баланс'**
  String get balance;

  /// No description provided for @profile.
  ///
  /// In ru, this message translates to:
  /// **'Профиль'**
  String get profile;

  /// No description provided for @myProfile.
  ///
  /// In ru, this message translates to:
  /// **'Мой профиль'**
  String get myProfile;

  /// No description provided for @news.
  ///
  /// In ru, this message translates to:
  /// **'Новости'**
  String get news;

  /// No description provided for @about.
  ///
  /// In ru, this message translates to:
  /// **'О нас'**
  String get about;

  /// No description provided for @back.
  ///
  /// In ru, this message translates to:
  /// **'Назад'**
  String get back;

  /// No description provided for @registration.
  ///
  /// In ru, this message translates to:
  /// **'Регистрация'**
  String get registration;

  /// No description provided for @forgotPassword.
  ///
  /// In ru, this message translates to:
  /// **'Забыли пароль?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In ru, this message translates to:
  /// **'Логин'**
  String get login;

  /// No description provided for @password.
  ///
  /// In ru, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @email.
  ///
  /// In ru, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterData.
  ///
  /// In ru, this message translates to:
  /// **'Введите данные'**
  String get enterData;

  /// No description provided for @or.
  ///
  /// In ru, this message translates to:
  /// **'или'**
  String get or;

  /// No description provided for @continueGuest.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить как гость'**
  String get continueGuest;

  /// No description provided for @continueAction.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get continueAction;

  /// No description provided for @createAccount.
  ///
  /// In ru, this message translates to:
  /// **'Создание аккаунта'**
  String get createAccount;

  /// No description provided for @passwordRecovery.
  ///
  /// In ru, this message translates to:
  /// **'Восстановление пароля'**
  String get passwordRecovery;

  /// No description provided for @requiredField.
  ///
  /// In ru, this message translates to:
  /// **'Обязательное поле'**
  String get requiredField;

  /// No description provided for @enterAtLeast8Characters.
  ///
  /// In ru, this message translates to:
  /// **'Введите не менее 8 символов'**
  String get enterAtLeast8Characters;

  /// No description provided for @maxLength.
  ///
  /// In ru, this message translates to:
  /// **'Максимальная длина'**
  String get maxLength;

  /// No description provided for @minLength.
  ///
  /// In ru, this message translates to:
  /// **'Минимальная длина'**
  String get minLength;

  /// No description provided for @register.
  ///
  /// In ru, this message translates to:
  /// **'Зарегистрироваться'**
  String get register;

  /// No description provided for @restore.
  ///
  /// In ru, this message translates to:
  /// **'Восстановить'**
  String get restore;

  /// No description provided for @thisIsEmail.
  ///
  /// In ru, this message translates to:
  /// **'Введите почту'**
  String get thisIsEmail;

  /// No description provided for @anErrorOccurred.
  ///
  /// In ru, this message translates to:
  /// **'Произошла ошибка'**
  String get anErrorOccurred;

  /// No description provided for @accountCreated.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт создан!'**
  String get accountCreated;

  /// No description provided for @save.
  ///
  /// In ru, this message translates to:
  /// **'Сохранить'**
  String get save;

  /// No description provided for @changePhoto.
  ///
  /// In ru, this message translates to:
  /// **'Изменить фото'**
  String get changePhoto;

  /// No description provided for @changePasswordAction.
  ///
  /// In ru, this message translates to:
  /// **'Сменить пароля'**
  String get changePasswordAction;

  /// No description provided for @oldPassword.
  ///
  /// In ru, this message translates to:
  /// **'Старый пароль'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль'**
  String get newPassword;

  /// No description provided for @change.
  ///
  /// In ru, this message translates to:
  /// **'Изменить'**
  String get change;

  /// No description provided for @name.
  ///
  /// In ru, this message translates to:
  /// **'Имя'**
  String get name;

  /// No description provided for @surname.
  ///
  /// In ru, this message translates to:
  /// **'Фамилия'**
  String get surname;

  /// No description provided for @logout.
  ///
  /// In ru, this message translates to:
  /// **'Выйти'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In ru, this message translates to:
  /// **'Удалить аккаунт'**
  String get deleteAccount;

  /// No description provided for @thereArePlaces.
  ///
  /// In ru, this message translates to:
  /// **'Есть места'**
  String get thereArePlaces;

  /// No description provided for @noSeatsAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Нет мест'**
  String get noSeatsAvailable;

  /// No description provided for @filter.
  ///
  /// In ru, this message translates to:
  /// **'Фильтровать'**
  String get filter;

  /// No description provided for @kitchen.
  ///
  /// In ru, this message translates to:
  /// **'Кухня'**
  String get kitchen;

  /// No description provided for @open.
  ///
  /// In ru, this message translates to:
  /// **'Открыта'**
  String get open;

  /// No description provided for @seatsAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Есть места'**
  String get seatsAvailable;

  /// No description provided for @sortBy.
  ///
  /// In ru, this message translates to:
  /// **'Сортировать по'**
  String get sortBy;

  /// No description provided for @recommended.
  ///
  /// In ru, this message translates to:
  /// **'Рекомендованные'**
  String get recommended;

  /// No description provided for @rating.
  ///
  /// In ru, this message translates to:
  /// **'Рейтинг'**
  String get rating;

  /// No description provided for @distance.
  ///
  /// In ru, this message translates to:
  /// **'Расстояние'**
  String get distance;

  /// No description provided for @cost.
  ///
  /// In ru, this message translates to:
  /// **'Стоимость'**
  String get cost;

  /// No description provided for @apply.
  ///
  /// In ru, this message translates to:
  /// **'Применить'**
  String get apply;

  /// No description provided for @tariffs.
  ///
  /// In ru, this message translates to:
  /// **'Тарифы'**
  String get tariffs;

  /// No description provided for @selectComputer.
  ///
  /// In ru, this message translates to:
  /// **'Выберите компьютер'**
  String get selectComputer;

  /// No description provided for @story.
  ///
  /// In ru, this message translates to:
  /// **'История'**
  String get story;

  /// No description provided for @topUpBalance.
  ///
  /// In ru, this message translates to:
  /// **'Пополнить баланс'**
  String get topUpBalance;

  /// No description provided for @excellent.
  ///
  /// In ru, this message translates to:
  /// **'Отличный'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In ru, this message translates to:
  /// **'Хороший'**
  String get good;

  /// No description provided for @bad.
  ///
  /// In ru, this message translates to:
  /// **'Плохой'**
  String get bad;

  /// No description provided for @selectPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Выберите период'**
  String get selectPeriod;

  /// No description provided for @backToHome.
  ///
  /// In ru, this message translates to:
  /// **'Назад на главную'**
  String get backToHome;

  /// No description provided for @home.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get home;

  /// No description provided for @all.
  ///
  /// In ru, this message translates to:
  /// **'Все'**
  String get all;

  /// No description provided for @catalog.
  ///
  /// In ru, this message translates to:
  /// **'Каталог'**
  String get catalog;

  /// No description provided for @shop.
  ///
  /// In ru, this message translates to:
  /// **'Магазин'**
  String get shop;

  /// No description provided for @reservation.
  ///
  /// In ru, this message translates to:
  /// **'Бронь'**
  String get reservation;

  /// No description provided for @currentBalance.
  ///
  /// In ru, this message translates to:
  /// **'Текущий баланс'**
  String get currentBalance;

  /// No description provided for @balanceReplenishment.
  ///
  /// In ru, this message translates to:
  /// **'Пополнить баланс'**
  String get balanceReplenishment;

  /// No description provided for @paymentMethods.
  ///
  /// In ru, this message translates to:
  /// **'Способы оплаты'**
  String get paymentMethods;

  /// No description provided for @paymentHistory.
  ///
  /// In ru, this message translates to:
  /// **'История платажей'**
  String get paymentHistory;

  /// No description provided for @clubsDirectory.
  ///
  /// In ru, this message translates to:
  /// **'Каталог клубов'**
  String get clubsDirectory;

  /// No description provided for @reset.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get reset;

  /// No description provided for @search.
  ///
  /// In ru, this message translates to:
  /// **'Поиск'**
  String get search;

  /// No description provided for @enterTheClubName.
  ///
  /// In ru, this message translates to:
  /// **'Введите название клуба'**
  String get enterTheClubName;

  /// No description provided for @computerBackup.
  ///
  /// In ru, this message translates to:
  /// **'Резерв компьютера'**
  String get computerBackup;

  /// No description provided for @selectTime.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать время'**
  String get selectTime;

  /// No description provided for @bookingDate.
  ///
  /// In ru, this message translates to:
  /// **'Дата'**
  String get bookingDate;

  /// No description provided for @ready.
  ///
  /// In ru, this message translates to:
  /// **'Готово'**
  String get ready;

  /// No description provided for @sorting.
  ///
  /// In ru, this message translates to:
  /// **'Сортировка'**
  String get sorting;

  /// No description provided for @reviews.
  ///
  /// In ru, this message translates to:
  /// **'Отзывы'**
  String get reviews;

  /// No description provided for @getDirections.
  ///
  /// In ru, this message translates to:
  /// **'Проложить маршрут'**
  String get getDirections;

  /// No description provided for @lastActivity.
  ///
  /// In ru, this message translates to:
  /// **'Последняя активность'**
  String get lastActivity;

  /// No description provided for @repeatBooking.
  ///
  /// In ru, this message translates to:
  /// **'Повторить бронь'**
  String get repeatBooking;

  /// No description provided for @notifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notifications;

  /// No description provided for @basket.
  ///
  /// In ru, this message translates to:
  /// **'Корзина'**
  String get basket;

  /// No description provided for @loginToAceGaming.
  ///
  /// In ru, this message translates to:
  /// **'Войти в ACE GAMING'**
  String get loginToAceGaming;

  /// No description provided for @toLogIntoTheApplicationChooseAMethodConvenientForYou.
  ///
  /// In ru, this message translates to:
  /// **'Для входа в приложение, \nвыберите удобный для вас способ'**
  String get toLogIntoTheApplicationChooseAMethodConvenientForYou;

  /// No description provided for @byLoggingInYouAgreeToThePrivacyPolicy.
  ///
  /// In ru, this message translates to:
  /// **'Авторизовавшись, вы соглашаетесь с \nПолитикой конфиденциальности'**
  String get byLoggingInYouAgreeToThePrivacyPolicy;

  /// No description provided for @loginViaApple.
  ///
  /// In ru, this message translates to:
  /// **'Войти через Apple'**
  String get loginViaApple;

  /// No description provided for @loginViaGoogle.
  ///
  /// In ru, this message translates to:
  /// **'Войти через Google'**
  String get loginViaGoogle;

  /// No description provided for @loginViaEmail.
  ///
  /// In ru, this message translates to:
  /// **'Войти через e-mail'**
  String get loginViaEmail;

  /// No description provided for @loginViaTelegram.
  ///
  /// In ru, this message translates to:
  /// **'Войти через Telegram'**
  String get loginViaTelegram;

  /// No description provided for @enterYourEmailAndPassword.
  ///
  /// In ru, this message translates to:
  /// **'Введите ваш e-mail и пароль'**
  String get enterYourEmailAndPassword;

  /// No description provided for @enterEmail.
  ///
  /// In ru, this message translates to:
  /// **'Введите e-mail'**
  String get enterEmail;

  /// No description provided for @enter.
  ///
  /// In ru, this message translates to:
  /// **'Войти'**
  String get enter;

  /// No description provided for @enterPassword.
  ///
  /// In ru, this message translates to:
  /// **'Введите пароль'**
  String get enterPassword;

  /// No description provided for @enterYourEmail.
  ///
  /// In ru, this message translates to:
  /// **'Введите ваш e-mail'**
  String get enterYourEmail;

  /// No description provided for @weWillSendAConfirmationCodeToYourRegisteredEmailToChangeYour.
  ///
  /// In ru, this message translates to:
  /// **'На зарегистрированный e-mail мы отправим код подтверждения для смены пароля'**
  String get weWillSendAConfirmationCodeToYourRegisteredEmailToChangeYour;

  /// No description provided for @weWillSendYouANewPasswordToYourRegisteredEmail.
  ///
  /// In ru, this message translates to:
  /// **'На зарегистрированный e-mail мы отправим вам новый пароль'**
  String get weWillSendYouANewPasswordToYourRegisteredEmail;

  /// No description provided for @codeFromTheLetter.
  ///
  /// In ru, this message translates to:
  /// **'Код из письма'**
  String get codeFromTheLetter;

  /// No description provided for @enterCode.
  ///
  /// In ru, this message translates to:
  /// **'Введите код'**
  String get enterCode;

  /// No description provided for @didNotReceiveTheCode.
  ///
  /// In ru, this message translates to:
  /// **'Не получили код?'**
  String get didNotReceiveTheCode;

  /// No description provided for @resend.
  ///
  /// In ru, this message translates to:
  /// **'Отправить снова'**
  String get resend;

  /// No description provided for @createANewPassword.
  ///
  /// In ru, this message translates to:
  /// **'Придумайте новый пароль'**
  String get createANewPassword;

  /// No description provided for @createANewPasswordForYourAccount.
  ///
  /// In ru, this message translates to:
  /// **'Создайте новый пароль для своего аккаунта'**
  String get createANewPasswordForYourAccount;

  /// No description provided for @createAPassword.
  ///
  /// In ru, this message translates to:
  /// **'Создать пароль'**
  String get createAPassword;

  /// No description provided for @repeatPassword.
  ///
  /// In ru, this message translates to:
  /// **'Повторите пароль'**
  String get repeatPassword;

  /// No description provided for @listOfComputerClubs.
  ///
  /// In ru, this message translates to:
  /// **'Список компьютерных клубов'**
  String get listOfComputerClubs;

  /// No description provided for @eachClubHasItsOwnBalance.
  ///
  /// In ru, this message translates to:
  /// **'У вас в каждом клубе есть собственный баланс'**
  String get eachClubHasItsOwnBalance;

  /// No description provided for @replenishment.
  ///
  /// In ru, this message translates to:
  /// **'Пополнение'**
  String get replenishment;

  /// No description provided for @paymentDetails.
  ///
  /// In ru, this message translates to:
  /// **'Детали платежа'**
  String get paymentDetails;

  /// No description provided for @print.
  ///
  /// In ru, this message translates to:
  /// **'Распечатать'**
  String get print;

  /// No description provided for @sendByEmail.
  ///
  /// In ru, this message translates to:
  /// **'Отправить на email'**
  String get sendByEmail;

  /// No description provided for @selectAComputerClub.
  ///
  /// In ru, this message translates to:
  /// **'Выберите компьютерный клуб'**
  String get selectAComputerClub;

  /// No description provided for @currentBalanceSum.
  ///
  /// In ru, this message translates to:
  /// **'Текущий остаток: {sum} ₸'**
  String currentBalanceSum(String sum);

  /// No description provided for @next.
  ///
  /// In ru, this message translates to:
  /// **'Далее'**
  String get next;

  /// No description provided for @topUpAmountT.
  ///
  /// In ru, this message translates to:
  /// **'Сумма пополнения, ₸'**
  String get topUpAmountT;

  /// No description provided for @enterAmount.
  ///
  /// In ru, this message translates to:
  /// **'Введите сумму'**
  String get enterAmount;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In ru, this message translates to:
  /// **'Выберите способ оплаты'**
  String get selectPaymentMethod;

  /// No description provided for @replenishmentMethods.
  ///
  /// In ru, this message translates to:
  /// **'Способы пополнения'**
  String get replenishmentMethods;

  /// No description provided for @myCards.
  ///
  /// In ru, this message translates to:
  /// **'Мои карты'**
  String get myCards;

  /// No description provided for @otherPaymentMethods.
  ///
  /// In ru, this message translates to:
  /// **'Другие способы оплаты'**
  String get otherPaymentMethods;

  /// No description provided for @addANewCard.
  ///
  /// In ru, this message translates to:
  /// **'Добавить новую карту'**
  String get addANewCard;

  /// No description provided for @confirmation.
  ///
  /// In ru, this message translates to:
  /// **'Подтверждение'**
  String get confirmation;

  /// No description provided for @paymentMethod.
  ///
  /// In ru, this message translates to:
  /// **'Способ оплаты'**
  String get paymentMethod;

  /// No description provided for @topUpAmount.
  ///
  /// In ru, this message translates to:
  /// **'Сумма пополнения'**
  String get topUpAmount;

  /// No description provided for @pay.
  ///
  /// In ru, this message translates to:
  /// **'Оплатить'**
  String get pay;

  /// No description provided for @card.
  ///
  /// In ru, this message translates to:
  /// **'Карта'**
  String get card;

  /// No description provided for @setAsDefault.
  ///
  /// In ru, this message translates to:
  /// **'Установить по умолчанию'**
  String get setAsDefault;

  /// No description provided for @removeCard.
  ///
  /// In ru, this message translates to:
  /// **'Удалить карту'**
  String get removeCard;

  /// No description provided for @addNewCard.
  ///
  /// In ru, this message translates to:
  /// **'Добавить новую карту'**
  String get addNewCard;

  /// No description provided for @validityPeriod.
  ///
  /// In ru, this message translates to:
  /// **'Срок действия'**
  String get validityPeriod;

  /// No description provided for @cardNumber.
  ///
  /// In ru, this message translates to:
  /// **'Номер карты'**
  String get cardNumber;

  /// No description provided for @addACard.
  ///
  /// In ru, this message translates to:
  /// **'Добавить карту'**
  String get addACard;

  /// No description provided for @totalPayable.
  ///
  /// In ru, this message translates to:
  /// **'Итого к оплате'**
  String get totalPayable;

  /// No description provided for @confirmPayment.
  ///
  /// In ru, this message translates to:
  /// **'Подтвердите оплату'**
  String get confirmPayment;

  /// No description provided for @oopsSomethingWentWrong.
  ///
  /// In ru, this message translates to:
  /// **'Упс, что то пошло не так'**
  String get oopsSomethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In ru, this message translates to:
  /// **'Попробуйте заново'**
  String get tryAgain;

  /// No description provided for @yourOrderWillBeDeliveredToYourTable.
  ///
  /// In ru, this message translates to:
  /// **'Ваш заказ будет доставлен к вашему столу '**
  String get yourOrderWillBeDeliveredToYourTable;

  /// No description provided for @thankYouForChoosingOurServiceWeWishYouBonAppetit.
  ///
  /// In ru, this message translates to:
  /// **'Спасибо, что выбрали наш сервис! Желаем приятного аппетита!'**
  String get thankYouForChoosingOurServiceWeWishYouBonAppetit;

  /// No description provided for @goingTo.
  ///
  /// In ru, this message translates to:
  /// **'Собирается'**
  String get goingTo;

  /// No description provided for @goToDetails.
  ///
  /// In ru, this message translates to:
  /// **'Перейти к деталям'**
  String get goToDetails;

  /// No description provided for @paymentAccepted.
  ///
  /// In ru, this message translates to:
  /// **'Оплата принята'**
  String get paymentAccepted;

  /// No description provided for @orderDetails.
  ///
  /// In ru, this message translates to:
  /// **'Детали заказа'**
  String get orderDetails;

  /// No description provided for @orderContents.
  ///
  /// In ru, this message translates to:
  /// **'Состав заказа:'**
  String get orderContents;

  /// No description provided for @personalInformation.
  ///
  /// In ru, this message translates to:
  /// **'Личные данные'**
  String get personalInformation;

  /// No description provided for @changePassword.
  ///
  /// In ru, this message translates to:
  /// **'Изменить пароль'**
  String get changePassword;

  /// No description provided for @selectLanguage.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать язык'**
  String get selectLanguage;

  /// No description provided for @promocode.
  ///
  /// In ru, this message translates to:
  /// **'Промокод'**
  String get promocode;

  /// No description provided for @whatIsYourName.
  ///
  /// In ru, this message translates to:
  /// **'Как вас зовут?'**
  String get whatIsYourName;

  /// No description provided for @enterName.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя'**
  String get enterName;

  /// No description provided for @activate.
  ///
  /// In ru, this message translates to:
  /// **'Активировать'**
  String get activate;

  /// No description provided for @enterPromocode.
  ///
  /// In ru, this message translates to:
  /// **'Введите промокод'**
  String get enterPromocode;

  /// No description provided for @writeAReview.
  ///
  /// In ru, this message translates to:
  /// **'Написать отзыв'**
  String get writeAReview;

  /// No description provided for @review.
  ///
  /// In ru, this message translates to:
  /// **'Отзыв'**
  String get review;

  /// No description provided for @startWritingOptional.
  ///
  /// In ru, this message translates to:
  /// **'Начните писать...(по желанию)'**
  String get startWritingOptional;

  /// No description provided for @send.
  ///
  /// In ru, this message translates to:
  /// **'Отправить'**
  String get send;

  /// No description provided for @cancel.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancel;

  /// No description provided for @enterYourName.
  ///
  /// In ru, this message translates to:
  /// **'Введите ваше имя'**
  String get enterYourName;

  /// No description provided for @createAPasswordRegist.
  ///
  /// In ru, this message translates to:
  /// **'Создайте пароль'**
  String get createAPasswordRegist;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In ru, this message translates to:
  /// **'Уже есть аккаунт?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @enterLogin.
  ///
  /// In ru, this message translates to:
  /// **'Введите логин'**
  String get enterLogin;

  /// No description provided for @enterYourEmailAndCreateAPassword.
  ///
  /// In ru, this message translates to:
  /// **'Введите ваш e-mail и создайте пароль'**
  String get enterYourEmailAndCreateAPassword;

  /// No description provided for @differentPasswords.
  ///
  /// In ru, this message translates to:
  /// **'Разные пароли'**
  String get differentPasswords;

  /// No description provided for @symbols.
  ///
  /// In ru, this message translates to:
  /// **'символов'**
  String get symbols;

  /// No description provided for @thereAreNoComputersInTheCurrentZone.
  ///
  /// In ru, this message translates to:
  /// **'В текущей зоне нет компьютеров'**
  String get thereAreNoComputersInTheCurrentZone;

  /// No description provided for @soonDots.
  ///
  /// In ru, this message translates to:
  /// **'Скоро...'**
  String get soonDots;

  /// No description provided for @noBalancesAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Нет доступных балансов'**
  String get noBalancesAvailable;

  /// No description provided for @loginViaLogin.
  ///
  /// In ru, this message translates to:
  /// **'Войти через логин'**
  String get loginViaLogin;

  /// No description provided for @enterYourLoginAndPassword.
  ///
  /// In ru, this message translates to:
  /// **'Введите свой логин пароль'**
  String get enterYourLoginAndPassword;

  /// No description provided for @yesDelete.
  ///
  /// In ru, this message translates to:
  /// **'Да, удалить'**
  String get yesDelete;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In ru, this message translates to:
  /// **'При удалении аккаунта все ваши данные будут безвозвратно удалены, включая баланс, игровой прогресс, статистику, историю бронирований и другие связанные данные. Восстановить удаленный аккаунт будет невозможно. Вы уверены, что хотите продолжить?'**
  String get deleteAccountWarning;

  /// No description provided for @areYouSureYouWantToExit.
  ///
  /// In ru, this message translates to:
  /// **'Вы уверены, что хотите выйти?'**
  String get areYouSureYouWantToExit;

  /// No description provided for @attention.
  ///
  /// In ru, this message translates to:
  /// **'Внимание'**
  String get attention;

  /// No description provided for @yesLogout.
  ///
  /// In ru, this message translates to:
  /// **'Да, выйти'**
  String get yesLogout;

  /// No description provided for @minimum.
  ///
  /// In ru, this message translates to:
  /// **'Минимально'**
  String get minimum;

  /// No description provided for @maximum.
  ///
  /// In ru, this message translates to:
  /// **'Максимально'**
  String get maximum;

  /// No description provided for @selectAction.
  ///
  /// In ru, this message translates to:
  /// **'Выберите действие'**
  String get selectAction;

  /// No description provided for @minutes.
  ///
  /// In ru, this message translates to:
  /// **'{n, plural, one{{n} минута} few{{n} минуты} many{{n} минут} other{{n} минут}}'**
  String minutes(num n);

  /// No description provided for @activeSession.
  ///
  /// In ru, this message translates to:
  /// **'Активная сессия'**
  String get activeSession;

  /// No description provided for @pcNumber.
  ///
  /// In ru, this message translates to:
  /// **'ПК №{n}'**
  String pcNumber(String n);

  /// No description provided for @timeLeft.
  ///
  /// In ru, this message translates to:
  /// **'Осталось'**
  String get timeLeft;

  /// No description provided for @tariff.
  ///
  /// In ru, this message translates to:
  /// **'Тариф'**
  String get tariff;

  /// No description provided for @bonuses.
  ///
  /// In ru, this message translates to:
  /// **'Бонусы'**
  String get bonuses;

  /// No description provided for @stopSession.
  ///
  /// In ru, this message translates to:
  /// **'Завершить сессию'**
  String get stopSession;

  /// No description provided for @yesStop.
  ///
  /// In ru, this message translates to:
  /// **'Завершить'**
  String get yesStop;

  /// No description provided for @stopSessionConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Сессия за компьютером будет завершена, компьютер освободится. Продолжить?'**
  String get stopSessionConfirm;

  /// No description provided for @somethingWentWrong.
  ///
  /// In ru, this message translates to:
  /// **'Что-то пошло не так'**
  String get somethingWentWrong;

  /// No description provided for @newPasswordSent.
  ///
  /// In ru, this message translates to:
  /// **'Новый пароль отправлен на вашу почту.'**
  String get newPasswordSent;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось сбросить пароль.'**
  String get resetPasswordFailed;

  /// No description provided for @accountDeleted.
  ///
  /// In ru, this message translates to:
  /// **'Аккаунт успешно удален'**
  String get accountDeleted;

  /// No description provided for @accountDeleteFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось удалить аккаунт'**
  String get accountDeleteFailed;

  /// No description provided for @passwordChanged.
  ///
  /// In ru, this message translates to:
  /// **'Пароль успешно изменен'**
  String get passwordChanged;

  /// No description provided for @passwordChangeFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось изменить пароль'**
  String get passwordChangeFailed;

  /// No description provided for @notificationsDenied.
  ///
  /// In ru, this message translates to:
  /// **'Доступ к уведомлениям запрещен!'**
  String get notificationsDenied;

  /// No description provided for @aceQr.
  ///
  /// In ru, this message translates to:
  /// **'Ace QR'**
  String get aceQr;

  /// No description provided for @langRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get langRussian;

  /// No description provided for @langEnglish.
  ///
  /// In ru, this message translates to:
  /// **'Английский'**
  String get langEnglish;

  /// No description provided for @langKazakh.
  ///
  /// In ru, this message translates to:
  /// **'Казахский'**
  String get langKazakh;

  /// No description provided for @privacyPolicyLink.
  ///
  /// In ru, this message translates to:
  /// **'Политика конфиденциальности >'**
  String get privacyPolicyLink;

  /// No description provided for @sessionEnded.
  ///
  /// In ru, this message translates to:
  /// **'Сессия завершена'**
  String get sessionEnded;

  /// No description provided for @noActiveSession.
  ///
  /// In ru, this message translates to:
  /// **'Активной сессии нет'**
  String get noActiveSession;

  /// No description provided for @sessionExpired.
  ///
  /// In ru, this message translates to:
  /// **'Сессия истекла, войдите заново'**
  String get sessionExpired;

  /// No description provided for @shopOrderPlaced.
  ///
  /// In ru, this message translates to:
  /// **'Заказ в магазине оформлен'**
  String get shopOrderPlaced;

  /// No description provided for @balanceUpdated.
  ///
  /// In ru, this message translates to:
  /// **'Баланс обновлён'**
  String get balanceUpdated;

  /// No description provided for @walletBalance.
  ///
  /// In ru, this message translates to:
  /// **'Баланс'**
  String get walletBalance;

  /// No description provided for @walletBonuses.
  ///
  /// In ru, this message translates to:
  /// **'Бонусы'**
  String get walletBonuses;

  /// No description provided for @topUpBy.
  ///
  /// In ru, this message translates to:
  /// **'{wallet}: пополнение на {sum}'**
  String topUpBy(String wallet, String sum);

  /// No description provided for @withdrawBy.
  ///
  /// In ru, this message translates to:
  /// **'{wallet}: списание {sum}'**
  String withdrawBy(String wallet, String sum);

  /// No description provided for @tariffPerMinute.
  ///
  /// In ru, this message translates to:
  /// **'Поминутно'**
  String get tariffPerMinute;

  /// No description provided for @tariffFree.
  ///
  /// In ru, this message translates to:
  /// **'Бесплатно'**
  String get tariffFree;

  /// No description provided for @tariffDefault.
  ///
  /// In ru, this message translates to:
  /// **'Тариф'**
  String get tariffDefault;

  /// No description provided for @clubsNearby.
  ///
  /// In ru, this message translates to:
  /// **'Клубы неподалеку'**
  String get clubsNearby;

  /// No description provided for @exclusiveInAce.
  ///
  /// In ru, this message translates to:
  /// **'Эксклюзивно в ACE'**
  String get exclusiveInAce;

  /// No description provided for @cancelBooking.
  ///
  /// In ru, this message translates to:
  /// **'Отменить бронь'**
  String get cancelBooking;

  /// No description provided for @viewDetails.
  ///
  /// In ru, this message translates to:
  /// **'Посмотреть детали'**
  String get viewDetails;

  /// No description provided for @pcActiveBooking.
  ///
  /// In ru, this message translates to:
  /// **'ПК №{n}, активная бронь'**
  String pcActiveBooking(String n);

  /// No description provided for @pcBookingAt.
  ///
  /// In ru, this message translates to:
  /// **'Бронь ПК №{n}, {day} в {time}'**
  String pcBookingAt(String n, String day, String time);

  /// No description provided for @bookingCancelled.
  ///
  /// In ru, this message translates to:
  /// **'Бронь успешно отменена'**
  String get bookingCancelled;

  /// No description provided for @bookingCancelFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось отменить бронь'**
  String get bookingCancelFailed;

  /// No description provided for @branchesLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить филиалы'**
  String get branchesLoadFailed;

  /// No description provided for @authFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось авторизоваться'**
  String get authFailed;

  /// No description provided for @soonBadge.
  ///
  /// In ru, this message translates to:
  /// **'Скоро'**
  String get soonBadge;

  /// No description provided for @tariffsLoadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить тарифы'**
  String get tariffsLoadFailed;

  /// No description provided for @selectTariff.
  ///
  /// In ru, this message translates to:
  /// **'Выберите тариф'**
  String get selectTariff;

  /// No description provided for @bookingPcAt.
  ///
  /// In ru, this message translates to:
  /// **'Бронирование ПК №{n}, {date}'**
  String bookingPcAt(String n, String date);

  /// No description provided for @reserve.
  ///
  /// In ru, this message translates to:
  /// **'Забронировать'**
  String get reserve;

  /// No description provided for @bookingSuccess.
  ///
  /// In ru, this message translates to:
  /// **'Успешное бронирование!'**
  String get bookingSuccess;

  /// No description provided for @pcReserved.
  ///
  /// In ru, this message translates to:
  /// **'ПК №{n} забронирован. Ждем вас!'**
  String pcReserved(String n);

  /// No description provided for @bookingDetails.
  ///
  /// In ru, this message translates to:
  /// **'Детали бронирования: {date}'**
  String bookingDetails(String date);

  /// No description provided for @thanksForChoosing.
  ///
  /// In ru, this message translates to:
  /// **'Спасибо, что выбрали наш сервис!\nЖелаем вам отличной игры!'**
  String get thanksForChoosing;

  /// No description provided for @couldNotReserve.
  ///
  /// In ru, this message translates to:
  /// **'Мы не смогли забронировать для вас ПК №{n}. Пожалуйста попробуйте заново'**
  String couldNotReserve(String n);

  /// No description provided for @startOver.
  ///
  /// In ru, this message translates to:
  /// **'Начать заново'**
  String get startOver;

  /// No description provided for @noTariffsAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Упс, нет доступных тарифов'**
  String get noTariffsAvailable;

  /// No description provided for @useMinuteBilling.
  ///
  /// In ru, this message translates to:
  /// **'Вы можете воспользоваться по минутной оплатой'**
  String get useMinuteBilling;

  /// No description provided for @openOnMap.
  ///
  /// In ru, this message translates to:
  /// **'Открыть на карте'**
  String get openOnMap;

  /// No description provided for @fromPerHour.
  ///
  /// In ru, this message translates to:
  /// **'от 500 ₸/час'**
  String get fromPerHour;

  /// No description provided for @seeMore.
  ///
  /// In ru, this message translates to:
  /// **'Смотреть подробнее'**
  String get seeMore;

  /// No description provided for @excellentRating.
  ///
  /// In ru, this message translates to:
  /// **'Отлично, 8.8'**
  String get excellentRating;

  /// No description provided for @reviewsCount1000.
  ///
  /// In ru, this message translates to:
  /// **'1000 отзывов'**
  String get reviewsCount1000;

  /// No description provided for @changeDateTime.
  ///
  /// In ru, this message translates to:
  /// **'Изменить дату и время'**
  String get changeDateTime;

  /// No description provided for @selectedPc.
  ///
  /// In ru, this message translates to:
  /// **'Выбран ПК №{n}'**
  String selectedPc(String n);

  /// No description provided for @legendFree.
  ///
  /// In ru, this message translates to:
  /// **'Свободен'**
  String get legendFree;

  /// No description provided for @legendBusySoon.
  ///
  /// In ru, this message translates to:
  /// **'Бронь · сервис'**
  String get legendBusySoon;

  /// No description provided for @legendBusy.
  ///
  /// In ru, this message translates to:
  /// **'Занят'**
  String get legendBusy;

  /// No description provided for @legendOff.
  ///
  /// In ru, this message translates to:
  /// **'Выключен'**
  String get legendOff;

  /// No description provided for @noComputers.
  ///
  /// In ru, this message translates to:
  /// **'Нет компьютеров'**
  String get noComputers;

  /// No description provided for @today.
  ///
  /// In ru, this message translates to:
  /// **'Сегодня'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In ru, this message translates to:
  /// **'Завтра'**
  String get tomorrow;

  /// No description provided for @hoursLabel.
  ///
  /// In ru, this message translates to:
  /// **'Часы'**
  String get hoursLabel;

  /// No description provided for @minutesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Минуты'**
  String get minutesLabel;

  /// No description provided for @shareTitle.
  ///
  /// In ru, this message translates to:
  /// **'Интересный раздел'**
  String get shareTitle;

  /// No description provided for @shareClubsText.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас я нахожусь в разделе \"Клубы\". Посмотри здесь!'**
  String get shareClubsText;

  /// No description provided for @shareNewsText.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас я читаю новость. Посмотри здесь!'**
  String get shareNewsText;

  /// No description provided for @outOf10.
  ///
  /// In ru, this message translates to:
  /// **'из 10'**
  String get outOf10;

  /// No description provided for @reviews15.
  ///
  /// In ru, this message translates to:
  /// **'15 отзывов'**
  String get reviews15;

  /// No description provided for @reviewTimeAgo.
  ///
  /// In ru, this message translates to:
  /// **'5 часов назад'**
  String get reviewTimeAgo;

  /// No description provided for @reviewAuthor.
  ///
  /// In ru, this message translates to:
  /// **'Deadpool 2016'**
  String get reviewAuthor;

  /// No description provided for @reviewText.
  ///
  /// In ru, this message translates to:
  /// **'Все отлично работает, удобное приложение'**
  String get reviewText;

  /// No description provided for @morningTariff.
  ///
  /// In ru, this message translates to:
  /// **'Утро (08:00 - 12:00)'**
  String get morningTariff;

  /// No description provided for @dayTariff.
  ///
  /// In ru, this message translates to:
  /// **'День (12:00 - 18:00)'**
  String get dayTariff;

  /// No description provided for @nightTariff.
  ///
  /// In ru, this message translates to:
  /// **'Ночь (22:00 - 08:00)'**
  String get nightTariff;

  /// No description provided for @twoGis.
  ///
  /// In ru, this message translates to:
  /// **'2ГИС'**
  String get twoGis;

  /// No description provided for @yandexMaps.
  ///
  /// In ru, this message translates to:
  /// **'Yandex Карты'**
  String get yandexMaps;

  /// No description provided for @googleMaps.
  ///
  /// In ru, this message translates to:
  /// **'Google Карты'**
  String get googleMaps;

  /// No description provided for @appleMaps.
  ///
  /// In ru, this message translates to:
  /// **'Apple Карты'**
  String get appleMaps;

  /// No description provided for @tryAgainLater.
  ///
  /// In ru, this message translates to:
  /// **'Повторите попытку позднее'**
  String get tryAgainLater;

  /// No description provided for @topUp100Kaspi.
  ///
  /// In ru, this message translates to:
  /// **'Пополнить на 100тг через Kaspi QR'**
  String get topUp100Kaspi;

  /// No description provided for @aroundTheClock.
  ///
  /// In ru, this message translates to:
  /// **'Круглосуточно'**
  String get aroundTheClock;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In ru, this message translates to:
  /// **'Разрешите доступ к камере в настройках.'**
  String get cameraPermissionDenied;

  /// No description provided for @authError.
  ///
  /// In ru, this message translates to:
  /// **'Ошибка авторизации'**
  String get authError;

  /// No description provided for @scannerOnlyInApp.
  ///
  /// In ru, this message translates to:
  /// **'Сканер доступен только в приложении'**
  String get scannerOnlyInApp;

  /// No description provided for @priceByTariff.
  ///
  /// In ru, this message translates to:
  /// **'Цена по тарифу \"{name}”'**
  String priceByTariff(String name);

  /// No description provided for @tariffDuration.
  ///
  /// In ru, this message translates to:
  /// **'Продолжительность тарифа'**
  String get tariffDuration;

  /// No description provided for @activityStub.
  ///
  /// In ru, this message translates to:
  /// **'activity'**
  String get activityStub;

  /// No description provided for @goToBasket.
  ///
  /// In ru, this message translates to:
  /// **'Перейти в корзину ({n})'**
  String goToBasket(String n);

  /// No description provided for @goToPayment.
  ///
  /// In ru, this message translates to:
  /// **'Перейти к оплате ({sum})'**
  String goToPayment(String sum);

  /// No description provided for @orderStatus.
  ///
  /// In ru, this message translates to:
  /// **'Статус заказа'**
  String get orderStatus;

  /// No description provided for @paidViaKaspi.
  ///
  /// In ru, this message translates to:
  /// **'Оплачено через Kaspi.kz'**
  String get paidViaKaspi;

  /// No description provided for @orderDeliveredToTable.
  ///
  /// In ru, this message translates to:
  /// **'Заказ будет доставлен к вашему столу'**
  String get orderDeliveredToTable;

  /// No description provided for @completedAtSample.
  ///
  /// In ru, this message translates to:
  /// **'Завершен, 18.12.2024 в 3:00'**
  String get completedAtSample;

  /// No description provided for @chargedByTariffNight.
  ///
  /// In ru, this message translates to:
  /// **'Списано с баланса, по тарифу “Ночь”'**
  String get chargedByTariffNight;

  /// No description provided for @sessionDuration.
  ///
  /// In ru, this message translates to:
  /// **'Продолжительность сессии'**
  String get sessionDuration;

  /// No description provided for @minutes120.
  ///
  /// In ru, this message translates to:
  /// **'120 минут'**
  String get minutes120;

  /// No description provided for @notifTopUpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Баланс в Adamar Solutions пополнен на сумму 5 000 ₸'**
  String get notifTopUpTitle;

  /// No description provided for @notifTopUpMeta.
  ///
  /// In ru, this message translates to:
  /// **'Пополнение • 21.12.2024, 23:43'**
  String get notifTopUpMeta;

  /// No description provided for @notifBookingTitle.
  ///
  /// In ru, this message translates to:
  /// **'✅ Новая бронь подтверждена'**
  String get notifBookingTitle;

  /// No description provided for @notifChargeTitle.
  ///
  /// In ru, this message translates to:
  /// **'💸 Списаны 2 500 ₸ по тарифу “ночь”'**
  String get notifChargeTitle;

  /// No description provided for @notifOrderTitle.
  ///
  /// In ru, this message translates to:
  /// **'🛒 Оформлен новый заказ в магазине на сумму 2 500 ₸'**
  String get notifOrderTitle;

  /// No description provided for @notifMeta.
  ///
  /// In ru, this message translates to:
  /// **'Adamar Solutions • 21.12.2024, 23:43'**
  String get notifMeta;

  /// No description provided for @sampleClubName.
  ///
  /// In ru, this message translates to:
  /// **'Adamar Solutions'**
  String get sampleClubName;

  /// No description provided for @sampleClubAddress.
  ///
  /// In ru, this message translates to:
  /// **'пр. Аль-Фараби 101'**
  String get sampleClubAddress;

  /// No description provided for @qrLogin.
  ///
  /// In ru, this message translates to:
  /// **'QR-вход'**
  String get qrLogin;

  /// No description provided for @dateAtTime.
  ///
  /// In ru, this message translates to:
  /// **'{date} в {time}'**
  String dateAtTime(String date, String time);

  /// No description provided for @loadFailed.
  ///
  /// In ru, this message translates to:
  /// **'Не удалось загрузить данные'**
  String get loadFailed;

  /// No description provided for @noActivityYet.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет активности — забронируйте компьютер или войдите по QR'**
  String get noActivityYet;

  /// No description provided for @commonHall.
  ///
  /// In ru, this message translates to:
  /// **'Общий зал'**
  String get commonHall;

  /// No description provided for @wallet.
  ///
  /// In ru, this message translates to:
  /// **'Кошелёк'**
  String get wallet;

  /// No description provided for @activity.
  ///
  /// In ru, this message translates to:
  /// **'Активность'**
  String get activity;

  /// No description provided for @freeNow.
  ///
  /// In ru, this message translates to:
  /// **'Свободно сейчас'**
  String get freeNow;

  /// No description provided for @favorites.
  ///
  /// In ru, this message translates to:
  /// **'Избранные'**
  String get favorites;

  /// No description provided for @now.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас'**
  String get now;

  /// No description provided for @pickDate.
  ///
  /// In ru, this message translates to:
  /// **'Другой день'**
  String get pickDate;

  /// No description provided for @selectDate.
  ///
  /// In ru, this message translates to:
  /// **'Выберите дату и время'**
  String get selectDate;

  /// No description provided for @topUp.
  ///
  /// In ru, this message translates to:
  /// **'Пополнить'**
  String get topUp;

  /// No description provided for @totalAcrossNetwork.
  ///
  /// In ru, this message translates to:
  /// **'Всего по сети'**
  String get totalAcrossNetwork;

  /// No description provided for @byClubs.
  ///
  /// In ru, this message translates to:
  /// **'По клубам'**
  String get byClubs;

  /// No description provided for @noFavoritesYet.
  ///
  /// In ru, this message translates to:
  /// **'Нет избранных клубов — нажмите ♡ на экране клуба'**
  String get noFavoritesYet;

  /// No description provided for @noFreeNow.
  ///
  /// In ru, this message translates to:
  /// **'Сейчас нет клубов со свободными ПК'**
  String get noFreeNow;

  /// No description provided for @freeCount.
  ///
  /// In ru, this message translates to:
  /// **'{n} свободно'**
  String freeCount(String n);

  /// No description provided for @freeOf.
  ///
  /// In ru, this message translates to:
  /// **'{free} из {total} свободно'**
  String freeOf(String free, String total);

  /// No description provided for @zoneBusy.
  ///
  /// In ru, this message translates to:
  /// **'{zone} занят'**
  String zoneBusy(String zone);

  /// No description provided for @tariffNow.
  ///
  /// In ru, this message translates to:
  /// **'сейчас тариф «{name}» {price}'**
  String tariffNow(String name, String price);

  /// No description provided for @chargedFromClubBalance.
  ///
  /// In ru, this message translates to:
  /// **'Спишется с баланса {club}: {sum}'**
  String chargedFromClubBalance(String club, String sum);

  /// No description provided for @reserveFor.
  ///
  /// In ru, this message translates to:
  /// **'Забронировать · {price}'**
  String reserveFor(String price);

  /// No description provided for @pcInZone.
  ///
  /// In ru, this message translates to:
  /// **'ПК №{pc} · {zone}'**
  String pcInZone(String pc, String zone);

  /// No description provided for @computersCount.
  ///
  /// In ru, this message translates to:
  /// **'{n} ПК'**
  String computersCount(String n);

  /// No description provided for @searchClubs.
  ///
  /// In ru, this message translates to:
  /// **'Поиск по клубам'**
  String get searchClubs;

  /// No description provided for @nothingFound.
  ///
  /// In ru, this message translates to:
  /// **'Ничего не найдено'**
  String get nothingFound;

  /// No description provided for @choosePcs.
  ///
  /// In ru, this message translates to:
  /// **'Выберите компьютеры'**
  String get choosePcs;

  /// No description provided for @choosePcsHint.
  ///
  /// In ru, this message translates to:
  /// **'Можно выбрать несколько ПК одной зоны — для себя и друзей. Комната бронируется целиком.'**
  String get choosePcsHint;

  /// No description provided for @selectedPcs.
  ///
  /// In ru, this message translates to:
  /// **'Выбрано ПК: {n}'**
  String selectedPcs(String n);

  /// No description provided for @roomSelected.
  ///
  /// In ru, this message translates to:
  /// **'Комната {name} · {n} ПК'**
  String roomSelected(String name, String n);

  /// No description provided for @staffHold.
  ///
  /// In ru, this message translates to:
  /// **'Забронирован кассиром'**
  String get staffHold;

  /// No description provided for @pcReservedShort.
  ///
  /// In ru, this message translates to:
  /// **'Забронирован'**
  String get pcReservedShort;

  /// No description provided for @dynamicPriceHint.
  ///
  /// In ru, this message translates to:
  /// **'Динамическая цена · прогноз на время брони'**
  String get dynamicPriceHint;

  /// No description provided for @friendsInBooking.
  ///
  /// In ru, this message translates to:
  /// **'Друзья в брони'**
  String get friendsInBooking;

  /// No description provided for @friendsInBookingHint.
  ///
  /// In ru, this message translates to:
  /// **'Друг займёт своё место без кода. Остальным местам подойдёт код брони.'**
  String get friendsInBookingHint;

  /// No description provided for @roomMembers.
  ///
  /// In ru, this message translates to:
  /// **'Участники комнаты'**
  String get roomMembers;

  /// No description provided for @roomMembersHint.
  ///
  /// In ru, this message translates to:
  /// **'Участники войдут в комнату без кода. Хозяином аренды остаётесь вы.'**
  String get roomMembersHint;

  /// No description provided for @noFriends.
  ///
  /// In ru, this message translates to:
  /// **'Друзей пока нет. Кто войдёт в клубе по коду вашей брони, станет вашим другом.'**
  String get noFriends;

  /// No description provided for @friendOwnPlace.
  ///
  /// In ru, this message translates to:
  /// **'своё место, без кода'**
  String get friendOwnPlace;

  /// No description provided for @you.
  ///
  /// In ru, this message translates to:
  /// **'Вы'**
  String get you;

  /// No description provided for @oneSeat.
  ///
  /// In ru, this message translates to:
  /// **'одно место'**
  String get oneSeat;

  /// No description provided for @byCode.
  ///
  /// In ru, this message translates to:
  /// **'По коду брони'**
  String get byCode;

  /// No description provided for @moreN.
  ///
  /// In ru, this message translates to:
  /// **'ещё {n}'**
  String moreN(String n);

  /// No description provided for @seatSwapHint.
  ///
  /// In ru, this message translates to:
  /// **'Кто за каким ПК — видно в «Моих бронях», там же друга можно пересадить.'**
  String get seatSwapHint;

  /// No description provided for @totalLine.
  ///
  /// In ru, this message translates to:
  /// **'{price} × {n} ПК, одна оплата'**
  String totalLine(String price, String n);

  /// No description provided for @totalRoom.
  ///
  /// In ru, this message translates to:
  /// **'{price} за комнату, одна оплата'**
  String totalRoom(String price);

  /// No description provided for @tooManyFriends.
  ///
  /// In ru, this message translates to:
  /// **'Друзей не больше, чем мест: {n}'**
  String tooManyFriends(String n);

  /// No description provided for @pcsBooked.
  ///
  /// In ru, this message translates to:
  /// **'ПК {names} забронированы. Ждем вас!'**
  String pcsBooked(String names);

  /// No description provided for @roomBooked.
  ///
  /// In ru, this message translates to:
  /// **'Комната {name} забронирована. Ждем вас!'**
  String roomBooked(String name);

  /// No description provided for @youOrByCode.
  ///
  /// In ru, this message translates to:
  /// **'вы или по коду'**
  String get youOrByCode;

  /// No description provided for @accessCode.
  ///
  /// In ru, this message translates to:
  /// **'Код брони'**
  String get accessCode;

  /// No description provided for @accessCodeHint.
  ///
  /// In ru, this message translates to:
  /// **'Друзья вводят код на ПК в клубе. Назначенным друзьям и участникам комнаты код не нужен.'**
  String get accessCodeHint;

  /// No description provided for @burnHint.
  ///
  /// In ru, this message translates to:
  /// **'Если не прийти, бронь сгорит в конце окна — деньги не возвращаются.'**
  String get burnHint;

  /// No description provided for @myBookings.
  ///
  /// In ru, this message translates to:
  /// **'Мои брони'**
  String get myBookings;

  /// No description provided for @noBookings.
  ///
  /// In ru, this message translates to:
  /// **'Активных броней нет'**
  String get noBookings;

  /// No description provided for @friendsBooking.
  ///
  /// In ru, this message translates to:
  /// **'Бронь друга {owner}'**
  String friendsBooking(String owner);

  /// No description provided for @assignFriend.
  ///
  /// In ru, this message translates to:
  /// **'Назначить друга'**
  String get assignFriend;

  /// No description provided for @removeFriend.
  ///
  /// In ru, this message translates to:
  /// **'Снять друга'**
  String get removeFriend;

  /// No description provided for @editMembers.
  ///
  /// In ru, this message translates to:
  /// **'Изменить участников'**
  String get editMembers;

  /// No description provided for @cancelBookingConfirm.
  ///
  /// In ru, this message translates to:
  /// **'Бронь отменится целиком, со всеми ПК. Деньги не возвращаются, тарифы останутся у вас в очереди.'**
  String get cancelBookingConfirm;

  /// No description provided for @openDoor.
  ///
  /// In ru, this message translates to:
  /// **'Открыть дверь'**
  String get openDoor;

  /// No description provided for @doorOpened.
  ///
  /// In ru, this message translates to:
  /// **'Команда на открытие отправлена'**
  String get doorOpened;

  /// No description provided for @doorNoLock.
  ///
  /// In ru, this message translates to:
  /// **'У этой зоны нет замка'**
  String get doorNoLock;

  /// No description provided for @doorCooldown.
  ///
  /// In ru, this message translates to:
  /// **'Дверь уже открывается'**
  String get doorCooldown;

  /// No description provided for @doorUnauthorized.
  ///
  /// In ru, this message translates to:
  /// **'Открыть дверь можно, если у вас идёт сессия или бронь в ближайший час'**
  String get doorUnauthorized;

  /// No description provided for @roomNotRenter.
  ///
  /// In ru, this message translates to:
  /// **'Управляет арендой хозяин комнаты'**
  String get roomNotRenter;

  /// No description provided for @roomMemberGone.
  ///
  /// In ru, this message translates to:
  /// **'Этот игрок уже не в комнате'**
  String get roomMemberGone;

  /// No description provided for @roomLeaveNotAllowed.
  ///
  /// In ru, this message translates to:
  /// **'Уйти с продолжением можно только при оплаченном тарифе'**
  String get roomLeaveNotAllowed;

  /// No description provided for @roomBookedByOthers.
  ///
  /// In ru, this message translates to:
  /// **'Комната забронирована'**
  String get roomBookedByOthers;

  /// No description provided for @pcBusyAt.
  ///
  /// In ru, this message translates to:
  /// **'ПК уже занят на это время'**
  String get pcBusyAt;

  /// No description provided for @notEnoughMoney.
  ///
  /// In ru, this message translates to:
  /// **'Недостаточно средств на балансе клуба'**
  String get notEnoughMoney;

  /// No description provided for @startOnFriendPc.
  ///
  /// In ru, this message translates to:
  /// **'Запустить на ПК друга'**
  String get startOnFriendPc;

  /// No description provided for @sessionStartedFor.
  ///
  /// In ru, this message translates to:
  /// **'Сессия запущена для {name}'**
  String sessionStartedFor(String name);

  /// No description provided for @placeClaimed.
  ///
  /// In ru, this message translates to:
  /// **'занял {name}'**
  String placeClaimed(String name);

  /// No description provided for @placeBurned.
  ///
  /// In ru, this message translates to:
  /// **'сгорело'**
  String get placeBurned;

  /// No description provided for @placeCancelled.
  ///
  /// In ru, this message translates to:
  /// **'отменено'**
  String get placeCancelled;

  /// No description provided for @unassignedSeat.
  ///
  /// In ru, this message translates to:
  /// **'свободное место'**
  String get unassignedSeat;

  /// No description provided for @leaveRoomTitle.
  ///
  /// In ru, this message translates to:
  /// **'В комнате остаются игроки'**
  String get leaveRoomTitle;

  /// No description provided for @transferTo.
  ///
  /// In ru, this message translates to:
  /// **'Передать аренду {name}'**
  String transferTo(String name);

  /// No description provided for @stopForAll.
  ///
  /// In ru, this message translates to:
  /// **'Завершить аренду для всех'**
  String get stopForAll;

  /// No description provided for @leaveContinue.
  ///
  /// In ru, this message translates to:
  /// **'Уйти — аренда продолжится до {time}'**
  String leaveContinue(String time);

  /// No description provided for @codeCopied.
  ///
  /// In ru, this message translates to:
  /// **'Код скопирован'**
  String get codeCopied;

  /// No description provided for @bookingLive.
  ///
  /// In ru, this message translates to:
  /// **'идёт сейчас'**
  String get bookingLive;

  /// No description provided for @noFreePcsSelected.
  ///
  /// In ru, this message translates to:
  /// **'Выберите хотя бы один свободный ПК'**
  String get noFreePcsSelected;

  /// No description provided for @selectZoneOnly.
  ///
  /// In ru, this message translates to:
  /// **'Все места брони должны быть в одной зоне'**
  String get selectZoneOnly;

  /// No description provided for @pcOffline.
  ///
  /// In ru, this message translates to:
  /// **'ПК выключен — включите его в клубе и попробуйте снова'**
  String get pcOffline;

  /// No description provided for @pcInUse.
  ///
  /// In ru, this message translates to:
  /// **'На этом ПК уже играют'**
  String get pcInUse;

  /// No description provided for @membersSaved.
  ///
  /// In ru, this message translates to:
  /// **'Участники сохранены'**
  String get membersSaved;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
