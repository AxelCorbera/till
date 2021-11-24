String MetodoPago(String id) {
  switch (id) {
    case "diners":
      return 'lib/assets/icons/logosMetodoPago/diners.png';
    case "argencard":
      return 'lib/assets/icons/logosMetodoPago/argencard.jpg';
    case "maestro":
      return 'lib/assets/icons/logosMetodoPago/maestro.png';
    case "debvisa":
      return 'lib/assets/icons/logosMetodoPago/visadebito.jpg';
    case "cencosud":
      return 'lib/assets/icons/logosMetodoPago/cencosud.jpg';
    case "debcabal":
      return 'lib/assets/icons/logosMetodoPago/cabalDebito.jpg';
    case "visa":
      return 'lib/assets/icons/logosMetodoPago/visa.png';
    case "master":
      return 'lib/assets/icons/logosMetodoPago/master.png';
    case "amex":
      return 'lib/assets/icons/logosMetodoPago/amex.png';
    case "naranja":
      return 'lib/assets/icons/logosMetodoPago/naranja.png';
    case "tarshop":
      return 'lib/assets/icons/logosMetodoPago/shopping.png';
    case "cabal":
      return 'lib/assets/icons/logosMetodoPago/cabal.png';
    case "debmaster":
      return 'lib/assets/icons/logosMetodoPago/master.png';
    case "cordobesa":
      return 'lib/assets/icons/logosMetodoPago/cordobesa.jpg';
    case "cmr":
      return 'lib/assets/icons/logosMetodoPago/cmr.jpg';
  }
  return "";
}
