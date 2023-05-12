abstract class HelperLoginStates{}

class HelperLoginInitialState extends HelperLoginStates{}
class HelperLoginISuccessState extends HelperLoginStates{}
class HelperLoginIErrorState extends HelperLoginStates{}

class HelperCreateUserSuccessState extends HelperLoginStates{}
class HelperCreateUserErrorState extends HelperLoginStates{}

class HelperUpdateUserSuccessState extends HelperLoginStates{}

class VerificationNumberFailed extends HelperLoginStates{}
class VerificationCodeSendSuccess extends HelperLoginStates{}
class PhoneVerifiedSuccess extends HelperLoginStates{}
class PhoneVerifiedError extends HelperLoginStates{}



