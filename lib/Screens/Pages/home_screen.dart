import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_mate/Components/bottom_bar.dart';
import 'package:money_mate/Screens/Pages/add_transactions.dart';
import 'package:money_mate/Screens/Pages/transaction_history.dart';
import 'package:money_mate/controllers/admob_service.dart';
import 'package:money_mate/controllers/local_notifications.dart';
import 'package:money_mate/controllers/user_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

final storage = GetStorage();
final _firStore = FirebaseFirestore.instance;
final email = storage.read('email');
const double _fabDimension = 56;

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  late Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  final _transitionType = ContainerTransitionType.fade;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  final _controller = Get.find<LocalNotificationsController>();
  final UserController _userController = Get.find();
  final AdMobService _service = AdMobService();

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
    _userController.getUser();
    _controller.initialize();
    setState(() {});
    _controller.configureLocalTimeZone();
    _controller.nextInstanceOfTenAM();
    _userController.totalExpanse = 0.obs;
    _userController.totalIncome = 0.obs;
    _userController.totalAmountCalculations();
    _controller.scheduleDailyTenAMNotification();
    _service.createInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sizedBoxVertical(),
                _sizedBoxVertical(),
                _headerWidget(),
                _sizedBoxVertical(),
                _incomeWidget(),
                const Padding(padding: EdgeInsets.only(top: 10)),
                _recentTransactions(),
                StreamBuilder<QuerySnapshot>(
                  stream: _firStore
                      .collection('Users')
                      .doc(email)
                      .collection('Transactions')
                      .orderBy("TimeStamp", descending: true)
                      .snapshots(),
                  // ignore: missing_return
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> querySnapshot) {
                    if (querySnapshot.hasError) {
                      return const Center(child: Text('Has Error'));
                    }
                    if (querySnapshot.connectionState ==
                        ConnectionState.waiting) {
                      const CupertinoActivityIndicator();
                    }
                    if (querySnapshot.data == null) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    if (querySnapshot.data!.docs.isEmpty) {
                      return _noTransactions();
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          addAutomaticKeepAlives: true,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          itemCount: querySnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot myTransaction =
                                querySnapshot.data!.docs[index];
                            return InkWell(
                              onTap: () => {
                                _service.showInterstitial(),
                                Get.to(() => TransactionHistory())
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: myTransaction['Type'] == 'Income'
                                            ? Colors.green[50]
                                            : Colors.red[50],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image(
                                              image: AssetImage(
                                                  "assets/${myTransaction['Category'].toString().toLowerCase()}_icon.png"),
                                              width: 30,
                                              height: 30,
                                              color: null,
                                              fit: BoxFit.cover,
                                              alignment: Alignment.center,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(myTransaction['SOI'] ??
                                                    'N/A'),
                                                Text(myTransaction[
                                                        'SelectedDate'] ??
                                                    'N/A'),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                myTransaction['Type'] ==
                                                        'Income'
                                                    ? Text(
                                                        myTransaction[
                                                                'Amount'] ??
                                                            'N/A',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.green),
                                                      )
                                                    : Text(
                                                        myTransaction[
                                                                'Amount'] ??
                                                            'N/A',
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                const SizedBox(width: 16),
                                                Icon(
                                                  CupertinoIcons
                                                      .arrow_turn_down_right,
                                                  color: Colors.grey[900],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: OpenContainer(
        transitionType: _transitionType,
        openBuilder: (context, openContainer) => const AddTransactions(),
        closedElevation: 6,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Colors.amber[200] as Color,
        closedBuilder: (context, openContainer) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                CupertinoIcons.add,
                color: colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
    );
  }

  void click() {
    if (kDebugMode) {
      print('Clicked');
    }
    if (animationController.isCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  Widget _headerWidget() {
    return GestureDetector(
      onTap: () => Get.to(const BottomHomeBar(index: 3)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Hero(
              tag: 'tag',
              child: GetBuilder<UserController>(builder: (_) {
                return Container(
                  width: 55.0,
                  height: 55.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/user_pic.png'),
                    ),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nice to see you again",
                    style: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  GetBuilder<UserController>(
                    builder: (_) => Shimmer.fromColors(
                      baseColor: Colors.grey[900] as Color,
                      highlightColor: Colors.grey[200] as Color,
                      child: Text(_userController.name,
                          style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _incomeWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Your monthly Income",
                    style: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text("₹"),
                      Obx(() {
                        return Text(
                          _userController.totalIncome.toString(),
                          style: TextStyle(
                              color: Colors.green[500],
                              fontWeight: FontWeight.bold,
                              fontSize: 35),
                        );
                      })
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Your monthly Expanses",
                    style: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text("₹"),
                      Obx(() {
                        return Text(
                          _userController.totalExpanse.toString(),
                          style: TextStyle(
                              color: Colors.red[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 35),
                        );
                      })
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _sizedBoxVertical() {
  return const SizedBox(height: 20);
}

Widget _recentTransactions() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          "Your Recent Transactions:",
          style:
              TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}

Widget _noTransactions() {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        "assets/no_transactions.gif",
      ),
      Text(
        'No Transactions Found in your History',
        style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      ),
      Text(
        'Try create one and Save Money',
        style: TextStyle(color: Colors.grey[400], fontStyle: FontStyle.italic),
      ),
    ],
  ));
}
