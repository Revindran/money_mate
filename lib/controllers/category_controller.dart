import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_mate/models/category_model.dart';

class CatController extends GetxController{
  var catList =[
    CatModel(0, 'None', const Image(image: AssetImage("assets/loading_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.fill,
      alignment: Alignment.center,)),
    CatModel(1, 'Interest', const Image(image: AssetImage("assets/interest_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(2, 'Deposit',const Image(image: AssetImage("assets/deposit_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(3, 'Business',const Image(image: AssetImage("assets/business_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.fill,
      alignment: Alignment.center,)),
    CatModel(4, 'Salary',const Image(image: AssetImage("assets/salary_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(5, 'Recharge',const Image(image: AssetImage("assets/recharge_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(6, 'Reward',const Image(image: AssetImage("assets/reward_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(7, 'Return',const Image(image: AssetImage("assets/return_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(8, 'Bank',const Image(image: AssetImage("assets/bank_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(9, 'Credit',const Image(image: AssetImage("assets/credit_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(10, 'Transfer',const Image(image: AssetImage("assets/transfer_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(11, 'Loan',const Image(image: AssetImage("assets/loan_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
    CatModel(12, 'Bill',const Image(image: AssetImage("assets/bill_icon.png"),width: 30,
      height: 30,
      color: null,
      fit: BoxFit.cover,
      alignment: Alignment.center,)),
  ].obs;

}