import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/pages/call_page.dart';
import 'package:unilink_flutter_app/pages/call_video_interface_page.dart';
import 'package:unilink_flutter_app/pages/call_video_received_interface_page.dart';
import 'package:unilink_flutter_app/pages/chat_detail_page.dart';
import 'package:unilink_flutter_app/pages/create_account_detail_page.dart';
import 'package:unilink_flutter_app/pages/create_account_page.dart';
import 'package:unilink_flutter_app/pages/detail_profile_member_page.dart';
import 'package:unilink_flutter_app/pages/edit_profile_page.dart';
import 'package:unilink_flutter_app/pages/google_map.dart';
import 'package:unilink_flutter_app/pages/group_create_page.dart';
import 'package:unilink_flutter_app/pages/group_edit_page.dart';
import 'package:unilink_flutter_app/pages/group_member_page.dart';
import 'package:unilink_flutter_app/pages/group_page.dart';
import 'package:unilink_flutter_app/pages/groups_page.dart';
import 'package:unilink_flutter_app/pages/login_page.dart';
import 'package:unilink_flutter_app/pages/looking_for_study_groups.dart';
import 'package:unilink_flutter_app/pages/main_page.dart';
import 'package:unilink_flutter_app/pages/member_card_page.dart';
import 'package:unilink_flutter_app/pages/member_invitation_page.dart';
import 'package:unilink_flutter_app/pages/my_groups_page.dart';
import 'package:unilink_flutter_app/pages/note_page.dart';
import 'package:unilink_flutter_app/pages/notifications_page.dart';
import 'package:unilink_flutter_app/pages/other_profile_ingroup_page.dart';
import 'package:unilink_flutter_app/pages/other_profile_page.dart';
import 'package:unilink_flutter_app/pages/party_invitation_page.dart';
import 'package:unilink_flutter_app/pages/post_question_answer_page.dart';
import 'package:unilink_flutter_app/pages/profile_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_base_info.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_email_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_gender_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_image_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_phone_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_school_major_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_skill_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/start_join_page.dart';
import 'package:unilink_flutter_app/pages/splash_page.dart';
import 'package:unilink_flutter_app/pages/suitable_groups_page.dart';
import 'package:unilink_flutter_app/pages/welcome_page.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_otp_page.dart';
import 'package:unilink_flutter_app/pages/filter_for_finding_group.dart';

class RouterGenerator {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case SPLASH_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => SplashPage());
        }
      case LOGIN_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => LoginPage());
        }
      case MAIN_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => MainPage());
        }
      case GROUPS_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => GroupsPage());
        }
      case REGISTER_BY_PHONE_INPUT_GENDER_ROUTE:
        {
          return MaterialPageRoute(
              builder: (_) => RegisterByPhoneInputGenderPage());
        }
      case REGISTER_BY_PHONE_INUT_PHONE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => RegisterByPhonePage());
        }
      case REGISTER_BY_PHONE_INPUT_EMAIL_ROUTE:
        {
          return MaterialPageRoute(
              builder: (_) => RegisterByPhoneInputEmailPage());
        }
      case REGISTER_BY_PHOME_BASE_INFO:
        {
          return MaterialPageRoute(builder: (_) => RegisterByPhone5Page());
        }
      case REGISTER_BY_PHONE_INPUT_SCHOOL_MAJOR_ROUTE:
        {
          return MaterialPageRoute(
              builder: (_) => RegisterByPhoneInputSchoolMajorPage());
        }
      case REGISTER_BY_PHONE_INPUT_SKILL_ROUTE:
        {
          return MaterialPageRoute(
              builder: (_) => RegisterByPhoneInputSkillPage());
        }
      case REGISTER_BY_PHONE_INPUT_IMAGE_ROUTE:
        {
          return MaterialPageRoute(
              builder: (_) => RegisterByPhoneInputImagePage());
        }
      case START_JOIN_APP_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => StartJoinApp());
        }
      case WELCOME_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => WelcomePage());
        }
      case GROUP_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => GroupPage());
        }
      case MY_GROUPS_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => MyGroupsPage());
        }
      case SUITABLE_GROUPS_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => SuitableGroupsPage());
        }
      case REGISTER_BY_PHONE_INPUT_OTP_ROUTE:
        {
          return MaterialPageRoute(
              builder: (_) => RegisterByPhoneInputOTPPage());
        }

      case OTHER_PROFILE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => OtherProfilePage());
        }
      case LOOKING_FOR_STUDY_GROUPS:
        {
          return MaterialPageRoute(builder: (_) => LookingForStudyGroup());
        }
      case GOOGLE_MAP_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => GoogleMapScreen());
        }
      case MEMBER_CARD_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => ShowPage());
        }
      case FILTER_FOR_FINDING_GROUP:
        {
          return MaterialPageRoute(builder: (_) => FilterForFindingGroup());
        }
      case CHAT_DETAIL_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => ChatDetailPage());
        }
      case POST_QUESTION_ANSWER:
        {
          return MaterialPageRoute(builder: (_) => PostQuestionAnswer());
        }
      case NOTE_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => NotePage());
        }
      case GROUP_CREATE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => GroupCreatePage());
        }
      case CREATE_ACCOUNT_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => CreateAccountPage());
        }
      case CREATE_ACCOUNT_DETAIL_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => CreateAccountDetailPage());
        }
      case CALL_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => CallPage());
        }
      case CALL_VIDEO_INTERFACE_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => CallVideoInterfacePage());
        }
      case CALL_VIDEO_RECEIVED_INTERFACE_PAGE_ROUTE:
        {
          return MaterialPageRoute(
              builder: (_) => CallVideoReceivedInterfacePage());
        }
      case NOTIFY_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => NotificationPage());
        }
      case DETAIL_PROFILE_MEMBER_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => DetailProfileMemberPage());
        }
      case GROUP_EDIT_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => GroupEditPage());
        }
      case GROUP_MEMBER_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => GroupMemberPage());
        }
      case OTHER_PROFILE_INGROUP_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => OtherProfileIngroupPage());
        }
      case EDIT_PROFILE_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => EditProfilePage());
        }
      case PROFILE_PAGE_ROUTE:
        {
          return MaterialPageRoute(builder: (_) => ProfilePage());
        }
      case MEMBER_INVITATION_PAGE:
        {
          return MaterialPageRoute(builder: (_) => MemberInvitationPage());
        }
      case PARTY_INVITATION_PAGE:
        {
          return MaterialPageRoute(builder: (_) => PartyInvitationPage());
        }
    }
  }
}
