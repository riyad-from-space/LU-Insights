import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedTransportation() async {
  final firestore = FirebaseFirestore.instance;

  // Seed members
  final members = [
    {
      'name': 'Md. Anwar Hossain',
      'designation': 'Transportation Manager',
      'contact': '01711-111111',
    },
    {
      'name': 'Sabbir Rahman',
      'designation': 'Driver',
      'contact': '01712-222222',
    },
    {
      'name': 'Rafiq Islam',
      'designation': 'Assistant',
      'contact': '01713-333333',
    },
  ];
  for (final member in members) {
    await firestore.collection('transportation_members').add(member);
  }

  // Seed schedules
  final schedules = [
    // Departures
    {
      'direction': 'to',
      'time': '8:00 AM',
      'routes': [
        {
          'routeNumber': 1,
          'busNumbers': ['101']
        },
        {
          'routeNumber': 2,
          'busNumbers': ['201']
        },
        {
          'routeNumber': 3,
          'busNumbers': ['301']
        },
        {
          'routeNumber': 4,
          'busNumbers': ['401', '402']
        },
      ],
    },
    {
      'direction': 'to',
      'time': '9:00 AM',
      'routes': [
        {
          'routeNumber': 1,
          'busNumbers': ['102']
        },
        {
          'routeNumber': 2,
          'busNumbers': ['202']
        },
        {
          'routeNumber': 3,
          'busNumbers': ['302']
        },
        {
          'routeNumber': 4,
          'busNumbers': ['403', '404']
        },
      ],
    },
    {
      'direction': 'to',
      'time': '10:00 AM',
      'routes': [
        {
          'routeNumber': 1,
          'busNumbers': ['103']
        },
        {
          'routeNumber': 2,
          'busNumbers': ['203']
        },
        {
          'routeNumber': 3,
          'busNumbers': ['303']
        },
        {
          'routeNumber': 4,
          'busNumbers': ['405', '406']
        },
      ],
    },
    {
      'direction': 'to',
      'time': '11:00 AM',
      'routes': [
        {
          'routeNumber': 1,
          'busNumbers': ['104']
        },
        {
          'routeNumber': 2,
          'busNumbers': ['204']
        },
        {
          'routeNumber': 3,
          'busNumbers': ['304']
        },
        {
          'routeNumber': 4,
          'busNumbers': ['407', '408']
        },
      ],
    },
    // Returns
    {
      'direction': 'from',
      'time': '2:00 PM',
      'routes': [
        {
          'routeNumber': 1,
          'busNumbers': ['105']
        },
        {
          'routeNumber': 2,
          'busNumbers': ['205']
        },
        {
          'routeNumber': 3,
          'busNumbers': ['305']
        },
        {
          'routeNumber': 4,
          'busNumbers': ['409', '410']
        },
      ],
    },
    {
      'direction': 'from',
      'time': '3:00 PM',
      'routes': [
        {
          'routeNumber': 1,
          'busNumbers': ['106']
        },
        {
          'routeNumber': 2,
          'busNumbers': ['206']
        },
        {
          'routeNumber': 3,
          'busNumbers': ['306']
        },
        {
          'routeNumber': 4,
          'busNumbers': ['411', '412']
        },
      ],
    },
    {
      'direction': 'from',
      'time': '4:00 PM',
      'routes': [
        {
          'routeNumber': 1,
          'busNumbers': ['107']
        },
        {
          'routeNumber': 2,
          'busNumbers': ['207']
        },
        {
          'routeNumber': 3,
          'busNumbers': ['307']
        },
        {
          'routeNumber': 4,
          'busNumbers': ['413', '414']
        },
      ],
    },
    {
      'direction': 'from',
      'time': '5:00 PM',
      'routes': [
        {
          'routeNumber': 1,
          'busNumbers': ['108']
        },
        {
          'routeNumber': 2,
          'busNumbers': ['208']
        },
        {
          'routeNumber': 3,
          'busNumbers': ['308']
        },
        {
          'routeNumber': 4,
          'busNumbers': ['415', '416']
        },
      ],
    },
  ];
  for (final schedule in schedules) {
    await firestore.collection('transportation_schedules').add(schedule);
  }

  // Seed a demo post
  await firestore.collection('transportation_posts').add({
    'title': 'Bus Delay Notice',
    'content':
        'Due to traffic, the 9:00 AM bus for Route 2 will be delayed by 15 minutes.',
    'authorId': 'transport_admin_1',
    'createdAt': DateTime.now(),
  });
}
