import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import '../Apis/addmycommentapi.dart';
import '../Apis/mylikedislikeapi.dart';
import '../CommonUtils/common_utils.dart';
import '../CommonUtils/string_files.dart';
import '../Models/commonmodel.dart';
import '../Models/transactionmodel.dart';
import '../Models/transactionmodel.dart';
import '../Pages/report_post_file.dart';
import '../globals.dart';
import 'custom_ui_widgets.dart';
import 'my_colors.dart';

class TransactionPost extends StatefulWidget {
  TransactionData? transactionData;
  Function? function;

  TransactionPost(TransactionData _transactionData, Function _function) {
    this.transactionData = _transactionData;
    this.function = _function;
  }
  @override
  State<StatefulWidget> createState() {
    return TransactionPostState();
  }
}

class TransactionPostState extends State<TransactionPost> {
  TransactionData? transactionData;
  String userid = '';
  @override
  void initState() {
    // TODO: implement initState
    userid = CommonUtils.getStrUserid();
    setState(() {
      transactionData = widget.transactionData;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: [
      Row(
        children: [
          InkWell(
            onTap: () {
              _createMyLikePublic(transactionData!.id, transactionData!.like);
            },
            child: transactionData!.like == 0
                ? Icon(AntDesign.hearto, color: MyColors.grey_color, size: 20)
                : Icon(AntDesign.heart, color: Colors.red, size: 20),
          ),
          SizedBox(width: 3),
          Text(
            transactionData!.likecount,
            style: TextStyle(
              fontFamily: 'Doomsday',
              color: MyColors.grey_color,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: () {
              print('-------------------');
              if (transactionData!.showmycomment == false) {
                transactionData!.showmycomment = true;
              } else {
                transactionData!.showmycomment = false;
              }

              setState(() {
                print('-------------------');
                transactionData = transactionData;
              });
            },
            child: Icon(
              FontAwesome.comment_o,
              color: MyColors.grey_color,
              size: 20,
            ),
          ),
          SizedBox(width: 3),
          Text(
            transactionData!.commentlist.length.toString(),
            style: TextStyle(
              fontFamily: 'Doomsday',
              color: MyColors.grey_color,
              fontSize: 16,
            ),
          ),
        ],
      ),
      SizedBox(height: 3),
      transactionData!.showmycomment == true
          ? Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics:
              NeverScrollableScrollPhysics(),
              itemCount: transactionData!
                  .commentlist
                  .length,
              itemBuilder: (context, ind) {
                return Container(
                  margin: EdgeInsets.all(4),
                  padding: EdgeInsets.fromLTRB(
                      10, 2, 2, 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: transactionData!
                              .commentlist[
                          ind]
                              .user_id !=
                              userid
                              ? Text(
                            transactionData!
                                .commentlist[
                            ind]
                                .username,
                            style: TextStyle(
                              fontFamily:
                              'Doomsday',
                              fontSize: 18,
                            ),
                          )
                              : Container(),),
                          InkWell(
                            onTap: (){
                              showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  builder: (BuildContext _context){
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      padding: const EdgeInsets.only(left: 12.0, top: 10, bottom: 10),
                                      child: Column(
                                        children: [

                                          InkWell(
                                            onTap: (){
                                              Navigator.of(_context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ReportPostScreen(
                                                    isPost: false, dataID: transactionData!
                                                      .commentlist[ind].id,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.flag, size: 20,),
                                                Text("Report this comment", style: TextStyle(fontSize: 18),)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Icon(Icons.more_horiz),
                          )
                        ],
                      ),

                      Text(
                        transactionData!
                            .commentlist[ind]
                            .comment,
                        style: TextStyle(
                          fontFamily: 'Doomsday',
                          color:
                          MyColors.grey_color,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: 3, right: 5),
                        alignment:
                        Alignment.centerRight,
                        child: Text(
                          CommonUtils
                              .timesAgoFeature(
                              transactionData!
                                  .commentlist[
                              ind]
                                  .timestamp),
                          style: TextStyle(
                            fontFamily:
                            'Doomsday',
                            color: Colors.black26,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          SizedBox(height: 5),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.fromLTRB(
                  20, 8, 20, 8),
              primary: MyColors.base_green_color,
              shape: CustomUiWidgets
                  .basicGreenButtonShape(),
            ),
            onPressed: () {
              _createCommentDialogBoxAndCallApi(
                  transactionData!.id);
            },
            child: Text(
              'Add Comment',
              style: TextStyle(
                fontFamily: 'Doomsday',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      )
          : Container()
    ]);
  }

  void _createMyLikePublic(int id, int like) async {
    if (Globals.isOnline) {
      transactionData!.like = transactionData!.like == 0 ? 1 : 0;
      String oldLikeCount = transactionData!.likecount;
      transactionData!.likecount = transactionData!.like == 0
          ? (int.parse(oldLikeCount) - 1).toString()
          : (int.parse(oldLikeCount) + 1).toString();
      setState(() {
        transactionData = transactionData;
      });
      try {
        MyLikeDislikeApi _likeApi = new MyLikeDislikeApi();
        CommonModel result =
            await _likeApi.search(id.toString(), like.toString());
      } catch (e) {
        CommonUtils.errorToast(context, e.toString());
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }
  void _createCommentDialogBoxAndCallApi(int id) {
    TextEditingController myCommentController = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    width: 250,
                    height: 250,
                    padding: EdgeInsets.all(15),
                    child: SizedBox.expand(
                      child: Column(
                        children: [
                          Text(
                            "Add Comment",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Doomsday',
                              decoration: TextDecoration.none,
                              color: MyColors.grey_color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 40),
                          Container(
                            height: 80,
                            color: Colors.white,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: myCommentController,
                              style: TextStyle(fontFamily: 'Doomsday'),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: MyColors.base_green_color, width: 2.0),
                                ),
                                hintText: 'Enter comment',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(60, 15, 60, 15),
                              primary: MyColors.base_green_color,
                              shape: CustomUiWidgets.basicGreenButtonShape(),
                            ),
                            onPressed: () {
                              if (myCommentController.text.isEmpty) {
                                CommonUtils.errorToast(context, "Enter comment");
                              } else {
                                Navigator.pop(context);
                                addCommentModel(
                                    id.toString(), myCommentController.text);
                              }
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Doomsday',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  );
                }),
          );
        });
  }
  void addCommentModel(String id, String comment) async {
    if (Globals.isOnline) {
      try {
        CommonUtils.showProgressDialogComplete(context, false);
        AddCommentModelApi _commentApi = new AddCommentModelApi();
        CommonModel result = await _commentApi.search(id, comment);
        if (result.status == "true") {
          Navigator.pop(context);
          widget.function!(true);
          // _callTransactionApi(false);
        } else {
          Navigator.pop(context);
          CommonUtils.errorToast(context, result.message);
        }
      } catch (e) {
        Navigator.pop(context);
        CommonUtils.errorToast(context, e.toString());
      }
    } else {
      CommonUtils.errorToast(context, StringMessage.network_Error);
    }
  }


}
