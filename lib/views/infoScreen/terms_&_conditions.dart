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
                    '1. GENERAL',
                    18.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(65, 64, 66, 1),
                    'Karbon'),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                    'By installing the software provided by Actron Engineering Pty Ltd ACN 002 767 240 ("ActronAir") relating to air conditioning services to be used on the Actron Link control platform and any upgrades from time to time ("Licensed Application") and any other software or documentation which enables the use of the Application, you agree to be bound by these terms of use ("Terms"). Please read these carefully before installation and/or acceptance.',
                    16.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(88, 89, 91, 1),
                    'Karbon'),
                const SizedBox(height: 20.0),
                CommonWidgets().text(
                    '2.PROPRIETARY RIGHTS AND LICENCE',
                    18.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(65, 64, 66, 1),
                    'Karbon'),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                    'All trademarks, copyright, database rights and other intellectual property rights of any nature in the Licensed Application together with the underlying software code are owned directly by ActronAir. ActronAir grant you a worldwide, non-exclusive, royalty-free revocable license to use the Application for your personal use in accordance with these Terms.',
                    16.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(88, 89, 91, 1),
                    'Karbon'),
                const SizedBox(height: 20.0),
                CommonWidgets().text(
                    '3. CONSENT TO USE DATA',
                    18.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(65, 64, 66, 1),
                    'Karbon'),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'You agree that ActronAir may collect and use technical data and related information, included but not limited to technical information about Your device, system and application software, that is gathered periodically to facilitate the provision of software updates, product support and other services to You (if any) related to the Licensed Application. ActronAir may use this information, as long as it is in a form that does not personally identify you, to improve its products or to provide services or technologies to you. ActronAir’s Privacy Policy is available on our website.',
                  16.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(height: 20.0),
                CommonWidgets().text(
                    '4.CONDITIONS OF USE',
                    18.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(65, 64, 66, 1),
                    'Karbon'),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'You will not, nor allow third parties on your behalf to (i) make and distribute copies of the Application (ii) attempt to copy, reproduce, alter, modify, reverse engineer, disassemble, decompile, transfer, exchange or translate the Licensed Application; or (iii) create derivative works of the Licensed Application of any kind whatsoever.',
                  16.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'The Licensed Application is currently made available to you free of charge for your personal, non-commercial use. ActronAir reserves the right to amend or withdraw the Licensed Application, or charge for the application or service provided to you in accordance with these Terms, at any time and for any reason.',
                  16.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'You agree and acknowledge that you are responsible for the use of the Licensed Application, which controls your air conditioning system operation. ActronAir will not be responsible for any loss, damage or liability that you or any other personnel may sustain as a result of operating your air conditioning unit via the Licensed Application or any other method.',
                  16.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'You acknowledge that the terms of agreement with your respective internet network provider will continue to apply when using the Licensed Application. As a result, you may be charged by your Internet Provider for access to network connection services for the duration of the connection while accessing the Licensed Application or any such third party charges as may arise. You accept responsibility for any such charges that arise.',
                  16.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CommonWidgets().text(
                    '5. TERMINATION',
                    18.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(65, 64, 66, 1),
                    'Karbon'),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'The application license is effective until terminated by you or ActronAir your rights under this license will terminate automatically without notice from ActronAir if you fail to comply with any term(s) of this license. Upon termination of the license you shall cease all use of the Licensed Application, and destroy all copies, full or partial, of the Licensed Application.',
                  16.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CommonWidgets().text(
                    '6. WARRANTIES',
                    18.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(65, 64, 66, 1),
                    'Karbon'),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'ActronAir’s liability is limited to, to the extent permissible by law and at ActronAir’s option in relation to the Application to:',
                  16.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    'a. the supply of Application again; or',
                    16.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(88, 89, 91, 1),
                    'Karbon',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    'b. the payment of the cost of having the Application supplied again (where there is a cost associated with the Application).',
                    16.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(88, 89, 91, 1),
                    'Karbon',
                  ),
                ),
                CommonWidgets().text(
                  'To the extent permitted at law, all other warranties whether implied or otherwise, not set out in these Terms are excluded and ActronAir is not liable in contract, tort (including, without limitation, negligence or breach of statutory duty) or otherwise to compensate you for:',
                  16.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    'a. any increased costs or expenses;',
                    14.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(88, 89, 91, 1),
                    'Karbon',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    'b. any loss of profit, revenue, business, contracts or anticipated savings;',
                    14.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(88, 89, 91, 1),
                    'Karbon',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    'c. any loss or expense resulting from a claim by a third party; or',
                    14.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(88, 89, 91, 1),
                    'Karbon',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: CommonWidgets().text(
                    'd. any special, indirect or consequential loss or damage of any nature whatsoever caused by ActronAir.',
                    14.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(88, 89, 91, 1),
                    'Karbon',
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                CommonWidgets().text(
                    '7. GENERAL',
                    18.0,
                    FontWeight.w600,
                    TextAlign.start,
                    const Color.fromRGBO(65, 64, 66, 1),
                    'Karbon'),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'These Terms are to be construed in accordance with the laws from time to time in the State of New South Wales and the Commonwealth of Australia and you submit to the exclusive jurisdiction of the courts in New South Wales.',
                  14.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'These Terms contain all of the terms and conditions of the contract between the parties and may only be varied by agreement in writing between the parties.',
                  14.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'Any conditions found to be void, unenforceable or illegal may, to that extent be severed from the Agreement.',
                  14.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                CommonWidgets().text(
                  'No waiver of any of these terms and conditions or failure to exercise a right or remedy by ActronAir will be considered to imply or constitute a further waiver by ActronAir of the same or any other term, condition, right or remedy.',
                  14.0,
                  FontWeight.w600,
                  TextAlign.start,
                  const Color.fromRGBO(88, 89, 91, 1),
                  'Karbon',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
