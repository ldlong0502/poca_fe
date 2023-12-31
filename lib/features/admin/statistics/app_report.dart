import 'package:flutter/material.dart';
import 'package:poca/configs/constants.dart';
import 'package:poca/screens/admin/admin_statistics.dart';
import 'package:poca/utils/resizable.dart';

class AppReport extends StatelessWidget {
  const AppReport({super.key, required this.cubit});
  final AdminStatisticsCubit cubit;
  @override
  Widget build(BuildContext context) {
    
    var mapItems = [
      {
        'title': 'User',
        'number': cubit.listUsers.where((element) => !element.isAdmin).length,
        'icon':'assets/icons/ic_admin_user.png',
      },
      {
        'title': 'Channels',
        'number': cubit.listChannels.length,
        'icon':'assets/icons/ic_admin_channel.png',
      },
      
      {
        'title': 'Topics',
        'number': cubit.listTopics.length,
        'icon':'assets/icons/ic_admin_topic.png',
      },
      {
        'title': 'Podcasts',
        'number': cubit.listPodcasts.length,
        'icon':'assets/icons/ic_admin_podcast.png',
      },
      {
        'title': 'Episodes',
        'number': cubit.listEpisodes.length,
        'icon':'assets/icons/ic_admin_episode.png',
      }
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('App Report' , style: TextStyle(
            color: textColor,
            fontSize: Resizable.font(context, 20),
            fontWeight: FontWeight.bold
          ),),
        ),
        
        SizedBox(
          height: 180,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            scrollDirection: Axis.horizontal,
            children: [
              ...mapItems.map((e) {
                return Container(
                  width: 160,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow:  [
                      BoxShadow(color: Colors.black.withOpacity(0.3), 
                      blurRadius: 4,
                      offset: const Offset(0, 3))
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(e['icon'].toString() ,color: primaryColor,),
                      Text(e['number'].toString() , style: TextStyle(
                          color: primaryColor , fontWeight: FontWeight.bold , fontSize: Resizable.font(context, 20)
                      ),),
                      Text(e['title'] as String , style: TextStyle(
                          color: textColor , fontWeight: FontWeight.bold , fontSize: Resizable.font(context, 20)
                      ),),
                    ],
                  ),
                );
              }).toList()
            ],
          ),
        )
      ],
    );
  }
}
