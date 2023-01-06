import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/home/screens/home_screen.dart';
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
    //route for create community screen
    '/mod-tools': (_) => const MaterialPage(
          child: ModToolsScreen(),
        ),
  },
);
