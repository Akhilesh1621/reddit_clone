import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screens/add_mods_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/home/screens/home_screen.dart';
import 'package:reddit_clone/home/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/community_screen.dart';

//loggedOut
final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginScreen(),
        )
  },
);

//loggedIn
final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),

    //route for create community screen
    '/create-community': (_) => const MaterialPage(
          child: CreateCommunityScreen(),
        ),

    //route forcommunity screen this is done bcz we need dynamic routes
    '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
            name: route.pathParameters['name']!,
          ),
        ),

    //route for mod tool

    '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModToolsScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),

    //route for edit community screen
    '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),

//route for add mods screen

    '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModsScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),

//route for user profile screen

    '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
  },
);
