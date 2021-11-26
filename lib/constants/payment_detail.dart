class Payment_Detail{

  String estado_detalle(String statusDetail, String metodoId, String cuotas){
    if(statusDetail == "cc_rejected_bad_filled_card_number"){
      return "Revisa el numero de tarjeta.";
    }else if(statusDetail == "cc_rejected_bad_filled_date"){
      return "Revisa la fecha de vencimiento.";
    }else if(statusDetail == "cc_rejected_bad_filled_other"){
      return "Revisa los datos.";
    }else if(statusDetail == "cc_rejected_bad_filled_security_code"){
      return "Revisa el código de seguridad de la tarjeta.";
    }else if(statusDetail == "cc_rejected_blacklist"){
      return "No pudimos procesar tu pago.";
    }else if(statusDetail == "cc_rejected_call_for_authorize"){
      return "Debes autorizar ante $metodoId el pago de amount.";
    }else if(statusDetail == "cc_rejected_card_disabled"){
      return "Llama a $metodoId para activar tu tarjeta o usa otro medio de pago.";
    }else if(statusDetail == "cc_rejected_card_error"){
      return "No pudimos procesar tu pago.";
    }else if(statusDetail == "cc_rejected_duplicated_payment"){
      return "Ya hiciste un pago por ese valor.";
    }else if(statusDetail == "cc_rejected_high_risk"){
      return "Tu pago fue rechazado.";
    }else if(statusDetail == "cc_rejected_insufficient_amount"){
      return "Tu $metodoId no tiene fondos suficientes.";
    }else if(statusDetail == "cc_rejected_invalid_installments"){
      return "$metodoId no procesa pagos en $cuotas cuotas.";
    }else if(statusDetail == "cc_rejected_max_attempts"){
      return "Llegaste al límite de intentos permitidos.";
    }else{
      return "$metodoId no procesó el pago.";
    }
  }
}