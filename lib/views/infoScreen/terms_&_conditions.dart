import 'package:airlink/common/common_widgets.dart';
import 'package:airlink/views/infoScreen/information_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Text(
              'Terms & Conditions',
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => {
              Get.to(
                () => const Information(),
              ),
            },
          ),
        ),
        body: SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonWidgets().text(
                  text: '1. GENERAL',
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(65, 64, 66, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'By installing the software provided by Actron Engineering Pty Ltd ACN 002 767 240 ("ActronAir") relating to air conditioning services to be used on the Actron Link control platform and any upgrades from time to time ("Licensed Application") and any other software or documentation which enables the use of the Application, you agree to be bound by these terms of use ("Terms"). Please read these carefully before installation and/or acceptance.',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(height: 20.0),
                CommonWidgets().text(
                  text: '2.PROPRIETARY RIGHTS AND LICENCE',
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(65, 64, 66, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'All trademarks, copyright, database rights and other intellectual property rights of any nature in the Licensed Application together with the underlying software code are owned directly by ActronAir. ActronAir grant you a worldwide, non-exclusive, royalty-free revocable license to use the Application for your personal use in accordance with these Terms.',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(height: 20.0),
                CommonWidgets().text(
                  text: '3. CONSENT TO USE DATA',
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(65, 64, 66, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'You agree that ActronAir may collect and use technical data and related information, included but not limited to technical information about Your device, system and application software, that is gathered periodically to facilitate the provision of software updates, product support and other services to You (if any) related to the Licensed Application. ActronAir may use this information, as long as it is in a form that does not personally identify you, to improve its products or to provide services or technologies to you. ActronAir’s Privacy Policy is available on our website.',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(height: 20.0),
                CommonWidgets().text(
                  text: '4.CONDITIONS OF USE',
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(65, 64, 66, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'You will not, nor allow third parties on your behalf to (i) make and distribute copies of the Application (ii) attempt to copy, reproduce, alter, modify, reverse engineer, disassemble, decompile, transfer, exchange or translate the Licensed Application; or (iii) create derivative works of the Licensed Application of any kind whatsoever.',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'The Licensed Application is currently made available to you free of charge for your personal, non-commercial use. ActronAir reserves the right to amend or withdraw the Licensed Application, or charge for the application or service provided to you in accordance with these Terms, at any time and for any reason.',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'You agree and acknowledge that you are responsible for the use of the Licensed Application, which controls your air conditioning system operation. ActronAir will not be responsible for any loss, damage or liability that you or any other personnel may sustain as a result of operating your air conditioning unit via the Licensed Application or any other method.',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'You acknowledge that the terms of agreement with your respective internet network provider will continue to apply when using the Licensed Application. As a result, you may be charged by your Internet Provider for access to network connection services for the duration of the connection while accessing the Licensed Application or any such third party charges as may arise. You accept responsibility for any such charges that arise.',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CommonWidgets().text(
                  text: '5. TERMINATION',
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(65, 64, 66, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'The application license is effective until terminated by you or ActronAir your rights under this license will terminate automatically without notice from ActronAir if you fail to comply with any term(s) of this license. Upon termination of the license you shall cease all use of the Licensed Application, and destroy all copies, full or partial, of the Licensed Application.',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CommonWidgets().text(
                  text: '6. WARRANTIES',
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(65, 64, 66, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'ActronAir’s liability is limited to, to the extent permissible by law and at ActronAir’s option in relation to the Application to:',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    text: 'a. the supply of Application again; or',
                    size: 16.0,
                    fontWeight: FontWeight.w600,
                    textColor: const Color.fromRGBO(88, 89, 91, 1),
                    fontFamily: 'Karbon',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    text:
                        'b. the payment of the cost of having the Application supplied again (where there is a cost associated with the Application).',
                    size: 16.0,
                    fontWeight: FontWeight.w600,
                    textColor: const Color.fromRGBO(88, 89, 91, 1),
                    fontFamily: 'Karbon',
                  ),
                ),
                CommonWidgets().text(
                  text:
                      'To the extent permitted at law, all other warranties whether implied or otherwise, not set out in these Terms are excluded and ActronAir is not liable in contract, tort (including, without limitation, negligence or breach of statutory duty) or otherwise to compensate you for:',
                  size: 16.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    text: 'a. any increased costs or expenses;',
                    size: 14.0,
                    fontWeight: FontWeight.w600,
                    textColor: const Color.fromRGBO(88, 89, 91, 1),
                    fontFamily: 'Karbon',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    text:
                        'b. any loss of profit, revenue, business, contracts or anticipated savings;',
                    size: 14.0,
                    fontWeight: FontWeight.w600,
                    textColor: const Color.fromRGBO(88, 89, 91, 1),
                    fontFamily: 'Karbon',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    text:
                        'c. any loss or expense resulting from a claim by a third party; or',
                    size: 14.0,
                    fontWeight: FontWeight.w600,
                    textColor: const Color.fromRGBO(88, 89, 91, 1),
                    fontFamily: 'Karbon',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    text:
                        'd. any special, indirect or consequential loss or damage of any nature whatsoever caused by ActronAir.',
                    size: 14.0,
                    fontWeight: FontWeight.w600,
                    textColor: const Color.fromRGBO(88, 89, 91, 1),
                    fontFamily: 'Karbon',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CommonWidgets().text(
                  text: '7. GENERAL',
                  size: 18.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(65, 64, 66, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'These Terms are to be construed in accordance with the laws from time to time in the State of New South Wales and the Commonwealth of Australia and you submit to the exclusive jurisdiction of the courts in New South Wales.',
                  size: 14.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'These Terms contain all of the terms and conditions of the contract between the parties and may only be varied by agreement in writing between the parties.',
                  size: 14.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'Any conditions found to be void, unenforceable or illegal may, to that extent be severed from the Agreement.',
                  size: 14.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  text:
                      'No waiver of any of these terms and conditions or failure to exercise a right or remedy by ActronAir will be considered to imply or constitute a further waiver by ActronAir of the same or any other term, condition, right or remedy.',
                  size: 14.0,
                  fontWeight: FontWeight.w600,
                  textColor: const Color.fromRGBO(88, 89, 91, 1),
                  fontFamily: 'Karbon',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
