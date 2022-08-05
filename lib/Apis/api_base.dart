



class Apis {


  static const apiKey = 'cab79c7b-52e9-4e4b-94fc-b0f32da14799';


  static const _baseUrl = 'https://test.laspa.lg.gov.ng/LaspaApp/Api/';
  static const _baseUrl1 = 'https://test.laspa.lg.gov.ng/LaspaApp/Api/Payment/';
  static const _baseUrl2 = 'https://test.laspa.lg.gov.ng/LaspaApp/Qrcode/location/';
  static const _baseUrl3 = 'https://test.laspa.lg.gov.ng/LaspaApp/Qrcode/';
  static const _baseUrl4 = 'https://app.prananet.io/LaspaApp/Qrcode/';




  static const loginApi = _baseUrl + 'agent_login';
  static const AgentGetDetails = _baseUrl + 'Agent-detailsGet';
  static const USSDcodegenerate = _baseUrl + 'USSDcodegenerate';
  static const CustomerParkingCreate = _baseUrl + 'CustomerParkingCreate';
  static const CustomerPushLinkPayment = _baseUrl + 'CustomerPushLinkPayment';
  static const CustomerParkingCreateCard = _baseUrl + 'CustomerParkingCreateCard';

  // static const CustomerParkingCreateCard = _baseUrl + 'CustomerParkingCreateCard';
  //

  static const QrcodeLocation = _baseUrl2;
  static const QrcodeLocationAlt = _baseUrl3;
  static const QrcodeLocationAlt1 = _baseUrl4;


  static const basesalt = 'https://test.laspa.lg.gov.ng/LaspaApp/Api/Payment/';
  static const AgentTicketGet = _baseUrl + 'AgentTicket';
  static const AgentParkingSpot = _baseUrl + 'AgentParkingSpot';

  static const Parking_Information_GetByID = _baseUrl + 'Parking_Information_GetByID';
  static const ParkingAgentpushUSSDcode = _baseUrl + 'ParkingAgentpushUSSDcode';
  static const ParkingAgentUSSDPayment = _baseUrl + 'ParkingAgentUSSDPayment';
  static const AgentBalance = _baseUrl + 'AgentBalance';


  static const AgentTransactionsGetByID = _baseUrl + 'AgentTransactionsGetByID';




  static const CustomerWalletPay = _baseUrl + 'customer_wallet_parkpayment';




}