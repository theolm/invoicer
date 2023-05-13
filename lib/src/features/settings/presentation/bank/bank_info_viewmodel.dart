import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:invoice_app/src/core/domain/data_models/bank.dart';
import 'package:invoice_app/src/core/domain/usecases/get_bank_info.dart';
import 'package:invoice_app/src/core/domain/usecases/save_bank_info.dart';
import 'package:invoice_app/src/core/domain/data_models/bank_info.dart';
import 'package:mobx/mobx.dart';

part 'bank_info_viewmodel.g.dart';

@injectable
class BankInfoViewModel extends _BankInfoViewModelBase
    with _$BankInfoViewModel {
  BankInfoViewModel(super._getBankInfo, super._saveBankInfo);
}

abstract class _BankInfoViewModelBase with Store {
  final IGetBankInfo _getBankInfo;
  final ISaveBankInfo _saveBankInfo;

  _BankInfoViewModelBase(this._getBankInfo, this._saveBankInfo) {
    var bankInfo = _getBankInfo.get();

    if(bankInfo != null) {
      beneficiaryNameController.text = bankInfo.beneficiaryName;

      ibanController.text = bankInfo.main.iban;
      swiftController.text = bankInfo.main.swift;
      bankNameController.text = bankInfo.main.bankName;
      bankAddressController.text = bankInfo.main.bankAddress;

      intIbanController.text = bankInfo.intermediary?.iban ?? "";
      intSwiftController.text = bankInfo.intermediary?.swift ?? "";
      intBankNameController.text = bankInfo.intermediary?.bankName ?? "";
      intBankAddressController.text = bankInfo.intermediary?.bankAddress ?? "";
    }
  }

  var beneficiaryNameController = TextEditingController();
  var ibanController = TextEditingController();
  var swiftController = TextEditingController();
  var bankNameController = TextEditingController();
  var bankAddressController = TextEditingController();
  var intSwiftController = TextEditingController();
  var intBankNameController = TextEditingController();
  var intBankAddressController = TextEditingController();
  var intIbanController = TextEditingController();

  Future saveBankInfo() async {
    var mainBank = Bank(
      ibanController.text,
      swiftController.text,
      bankNameController.text,
      bankAddressController.text,
    );

    var intermediaryBank = Bank(
      intIbanController.text,
      intSwiftController.text,
      intBankNameController.text,
      intBankAddressController.text,
    );

    var bankInfo = BankInfo(
      beneficiaryNameController.text,
      mainBank,
      intermediaryBank,
    );
    await _saveBankInfo.save(bankInfo);
  }
}
