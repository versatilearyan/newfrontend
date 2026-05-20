import 'package:flutter/material.dart';

// ── Post ──────────────────────────────────────────────────────────────────────
class Post {
  final String id;
  final String? title;
  final String content;
  final String timeAgo;
  final String? university;
  final String? lounge;
  final int likes;
  final int comments;
  final List<String> tags;
  final bool isAnonymous;
  final String username;
  final Color avatarColor;
  final String avatarInitials;

  const Post({
    required this.id,
    this.title,
    required this.content,
    required this.timeAgo,
    this.university,
    this.lounge,
    this.likes = 0,
    this.comments = 0,
    this.tags = const [],
    this.isAnonymous = true,
    this.username = 'Anonymous',
    this.avatarColor = const Color(0xFF3B5BDB),
    this.avatarInitials = 'A',
  });
}

// ── Comment ───────────────────────────────────────────────────────────────────
class Comment {
  final String id;
  final String username;
  final Color avatarColor;
  final String avatarInitials;
  final String? university;
  final String content;
  final String timeAgo;
  final int likes;
  final List<Comment> replies;

  const Comment({
    required this.id,
    required this.username,
    required this.avatarColor,
    required this.avatarInitials,
    this.university,
    required this.content,
    required this.timeAgo,
    this.likes = 0,
    this.replies = const [],
  });
}

// ── Lounge ────────────────────────────────────────────────────────────────────
class Lounge {
  final String id;
  final String name;
  final String? university;
  final int members;
  final int posts;
  final String? imageUrl;        // banner photo
  final String? profileImageUrl; // ✅ profile/avatar photo
  final String category;

  const Lounge({
    required this.id,
    required this.name,
    this.university,
    this.members = 0,
    this.posts = 0,
    this.imageUrl,
    this.profileImageUrl,
    required this.category,
  });
}

// ── Message ───────────────────────────────────────────────────────────────────
class Message {
  final String id;
  final String sender;
  final String preview;
  final String timeAgo;
  final bool isUnread;
  final String? university;

  const Message({
    required this.id,
    required this.sender,
    required this.preview,
    required this.timeAgo,
    this.isUnread = false,
    this.university,
  });
}

// ── 20 Lounges ────────────────────────────────────────────────────────────────
final sampleLounges = [
  const Lounge(id: 'l1',  name: 'Confessions',       members: 8400,  posts: 320, category: 'Confessions',
    imageUrl:        'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1509909756405-be0199881695?w=200&q=80'),
  const Lounge(id: 'l2',  name: 'Crush Corner',       members: 6200,  posts: 280, category: 'Romance',
    imageUrl:        'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=200&q=80'),
  const Lounge(id: 'l3',  name: 'Relationship Talks', members: 5100,  posts: 210, category: 'Romance',
    imageUrl:        'https://images.unsplash.com/photo-1474552226712-ac0f0961a954?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=200&q=80'),
  const Lounge(id: 'l4',  name: 'Campus Secrets',     members: 9800,  posts: 540, category: 'Confessions',
    imageUrl:        'https://images.unsplash.com/photo-1562774053-701939374585?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1562774053-701939374585?w=200&q=80'),
  const Lounge(id: 'l5',  name: 'Midnight Thoughts',  members: 4300,  posts: 190, category: 'General',
    imageUrl:        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=200&q=80'),
  const Lounge(id: 'l6',  name: 'Placement Pressure', members: 7600,  posts: 430, category: 'Career',
    imageUrl:        'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=200&q=80'),
  const Lounge(id: 'l7',  name: 'Engineering Lounge', members: 11200, posts: 670, category: 'Academics',
    imageUrl:        'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=200&q=80'),
  const Lounge(id: 'l8',  name: 'Meme Central',       members: 15400, posts: 890, category: 'Memes',
    imageUrl:        'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=200&q=80'),
  const Lounge(id: 'l9',  name: 'Hostel Life',        members: 6800,  posts: 360, category: 'Housing',
    imageUrl:        'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=200&q=80'),
  const Lounge(id: 'l10', name: 'College Drama',      members: 10300, posts: 750, category: 'Social',
    imageUrl:        'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=200&q=80'),
  const Lounge(id: 'l11', name: 'Mental Health',      members: 4900,  posts: 180, category: 'Wellness',
    imageUrl:        'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=200&q=80'),
  const Lounge(id: 'l12', name: 'Study Together',     members: 7200,  posts: 310, category: 'Academics',
    imageUrl:        'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b6f6e?w=200&q=80'),
  const Lounge(id: 'l13', name: 'Internship Hub',     members: 8900,  posts: 520, category: 'Career',
    imageUrl:        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=200&q=80'),
  const Lounge(id: 'l14', name: 'Anonymous Rants',    members: 12100, posts: 810, category: 'Rants',
    imageUrl:        'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=200&q=80'),
  const Lounge(id: 'l15', name: 'Situationships',     members: 5600,  posts: 290, category: 'Romance',
    imageUrl:        'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1474552226712-ac0f0961a954?w=200&q=80'),
  const Lounge(id: 'l16', name: 'Music & Vibes',      members: 6100,  posts: 240, category: 'Entertainment',
    imageUrl:        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=200&q=80'),
  const Lounge(id: 'l17', name: 'Fitness Club',       members: 3800,  posts: 160, category: 'Sports',
    imageUrl:        'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=200&q=80'),
  const Lounge(id: 'l18', name: 'Startup Circle',     members: 4200,  posts: 200, category: 'Career',
    imageUrl:        'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=200&q=80'),
  const Lounge(id: 'l19', name: 'Fashion & Fits',     members: 5300,  posts: 270, category: 'Lifestyle',
    imageUrl:        'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=200&q=80'),
  const Lounge(id: 'l20', name: 'Late Night Chats',   members: 7800,  posts: 480, category: 'General',
    imageUrl:        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
    profileImageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80'),
];

// ── Sample Posts (mapped to new lounges) ─────────────────────────────────────
final samplePosts = [
  Post(
    id: '1',
    username: "CSE'24",
    avatarInitials: 'C',
    avatarColor: const Color(0xFF7C3AED),
    university: 'NIT Trichy',
    lounge: 'Confessions',
    timeAgo: '12h',
    title: 'I cried in the library and nobody noticed',
    content: 'Was having a really bad day, sat in the corner of the library and just broke down. Three hours in that chair. Nobody even looked up from their laptops.',
    likes: 2841,
    comments: 312,
  ),
  Post(
    id: '2',
    username: "MECH'25",
    avatarInitials: 'M',
    avatarColor: const Color(0xFF0891B2),
    university: 'VIT Vellore',
    lounge: 'Placement Pressure',
    timeAgo: '1d',
    title: 'Rejected by 14 companies in a row — still going',
    content: 'Season started in Aug. 14 rejections, 3 still pending. Resume reviewed 6 times. I refuse to give up. Who else is in this boat right now?',
    likes: 4120,
    comments: 438,
  ),
  Post(
    id: '3',
    username: "CSE'26",
    avatarInitials: 'C',
    avatarColor: const Color(0xFFEF4444),
    university: 'IIIT Hyderabad',
    lounge: 'Engineering Lounge',
    timeAgo: '1d',
    title: "I've been pretending to understand DSA for 2 years",
    content: "Placement season is coming. I'm cooked. Send help. I nod along in every class but the moment I open LeetCode my brain goes completely blank.",
    likes: 5641,
    comments: 487,
  ),
  Post(
    id: '4',
    username: "IT'25",
    avatarInitials: 'I',
    avatarColor: const Color(0xFF059669),
    university: 'IIM Bangalore',
    lounge: 'Internship Hub',
    timeAgo: '3h',
    title: 'Got a PPO from my dream company — here\'s what worked',
    content: 'After 8 months of rejections I finally have a Pre-Placement Offer. Happy to share exactly what changed in my approach. Drop your questions below.',
    likes: 3256,
    comments: 273,
  ),
  Post(
    id: '5',
    username: "ECE'24",
    avatarInitials: 'E',
    avatarColor: const Color(0xFFD97706),
    university: 'BITS Pilani',
    lounge: 'Anonymous Rants',
    timeAgo: '6h',
    title: 'Why do professors assign 3 assignments due on the same day?',
    content: 'Monday: 3 submissions. Tuesday: quiz. Wednesday: lab viva. Thursday: repeat. I have not slept properly since October and it is now May.',
    likes: 7891,
    comments: 564,
  ),
  Post(
    id: '6',
    username: "ANON",
    avatarInitials: 'A',
    avatarColor: const Color(0xFFEC4899),
    university: 'Delhi University',
    lounge: 'Crush Corner',
    timeAgo: '4h',
    title: 'Sent my crush a meme at 2am and now I can\'t sleep',
    content: 'It\'s been seen. No reply. Three hours ago. The meme was funny I promise. This is the longest night of my life.',
    likes: 6120,
    comments: 891,
  ),
  Post(
    id: '7',
    username: "MBA'25",
    avatarInitials: 'B',
    avatarColor: const Color(0xFF3B5BDB),
    university: 'IIT Bombay',
    lounge: 'Meme Central',
    timeAgo: '2h',
    title: 'When the prof says "this will definitely be in the exam"',
    content: 'It was never in the exam. It was never in the exam. It was never in the exam. I studied that topic for 6 hours. It was never in the exam.',
    likes: 9430,
    comments: 1024,
  ),
  Post(
    id: '8',
    username: "CIVIL'24",
    avatarInitials: 'V',
    avatarColor: const Color(0xFF7C3AED),
    university: 'NIT Warangal',
    lounge: 'Hostel Life',
    timeAgo: '8h',
    title: 'My roommate hasn\'t spoken to me in 2 weeks after I ate his Maggi',
    content: 'It was 3am. I was hungry. One packet. I said sorry. He made a whiteboard timetable for the kitchen. We now schedule our cooking hours.',
    likes: 8230,
    comments: 743,
  ),
  Post(
    id: '9',
    username: "ANON",
    avatarInitials: 'A',
    avatarColor: const Color(0xFF059669),
    lounge: 'Mental Health',
    timeAgo: '5h',
    title: 'Struggling this semester and finally asked for help',
    content: 'Posted here a month ago about feeling completely lost. Today I actually went to the campus counsellor. It was hard. But it helped. If you\'re spiralling — please reach out.',
    likes: 4890,
    comments: 312,
  ),
  Post(
    id: '10',
    username: "ANON",
    avatarInitials: 'A',
    avatarColor: const Color(0xFFEF4444),
    university: 'Manipal University',
    lounge: 'Situationships',
    timeAgo: '7h',
    title: '"We\'re just talking" for 8 months now',
    content: 'Not together. Not strangers. Texts every day. Plans every weekend. But the second I ask where this is going — suddenly very busy. Make it make sense.',
    likes: 7120,
    comments: 934,
  ),
];

final trendingPosts = [
  Post(
    id: 't1',
    username: "CS'24",
    avatarInitials: 'C',
    avatarColor: const Color(0xFF3B5BDB),
    university: 'Stanford University',
    lounge: 'Internship Hub',
    timeAgo: '2h',
    title: 'INTERNSHIP MEGATHREAD — Summer 2025',
    content: 'Drop your referrals, prep resources, and interview experiences here. SWE, Product, Design — all welcome. Let\'s help each other.',
    likes: 5560,
    comments: 1230,
  ),
  Post(
    id: 't2',
    username: "ANON",
    avatarInitials: 'A',
    avatarColor: const Color(0xFF7C3AED),
    lounge: 'Campus Secrets',
    timeAgo: '4h',
    title: 'There\'s a hidden rooftop in the library building most students don\'t know about',
    content: 'Fourth floor, door at the end of the corridor marked "storage". It\'s unlocked. Best view on campus. You\'re welcome.',
    likes: 8890,
    comments: 2010,
  ),
  Post(
    id: 't3',
    username: "CIVIL'25",
    avatarInitials: 'V',
    avatarColor: const Color(0xFF059669),
    university: 'IIT Madras',
    lounge: 'Midnight Thoughts',
    timeAgo: '1d',
    title: 'Is anyone else terrified of graduating?',
    content: 'Everyone acts like final year is exciting. I\'m just scared. No plan. No idea what I\'m doing. The whole "real world" thing feels fake until it doesn\'t.',
    likes: 6710,
    comments: 834,
  ),
  Post(
    id: 't4',
    username: "MBA'24",
    avatarInitials: 'B',
    avatarColor: const Color(0xFFD97706),
    university: 'IIM Calcutta',
    lounge: 'College Drama',
    timeAgo: '5h',
    title: 'The groupism in our batch is out of control',
    content: 'Six months into college and it\'s already high school all over again. Exclusive circles, whisper networks, deliberate exclusions. Can we be adults please?',
    likes: 4230,
    comments: 567,
  ),
  Post(
    id: 't5',
    username: "ANON",
    avatarInitials: 'A',
    avatarColor: const Color(0xFF0891B2),
    lounge: 'Late Night Chats',
    timeAgo: '3h',
    title: 'It\'s 3am. What\'s keeping you awake?',
    content: 'Could be assignments. Could be that text you sent. Could be the question of what you\'re doing with your life. Drop it below. We\'re all here.',
    likes: 9120,
    comments: 1487,
  ),
];

// ── Sample Comments ───────────────────────────────────────────────────────────
List<Comment> sampleComments(String postId) => [
  Comment(
    id: 'c1',
    username: "ECE'25",
    avatarInitials: 'E',
    avatarColor: const Color(0xFF059669),
    university: 'NIT Trichy',
    content: 'This hits way too close to home. You\'re not alone though, I promise.',
    timeAgo: '10m',
    likes: 247,
    replies: [
      Comment(
        id: 'c1r1',
        username: "CSE'26",
        avatarInitials: 'C',
        avatarColor: const Color(0xFF7C3AED),
        content: 'Exactly what I needed to hear today. Thank you.',
        timeAgo: '8m',
        likes: 89,
      ),
      Comment(
        id: 'c1r2',
        username: "MECH'24",
        avatarInitials: 'M',
        avatarColor: const Color(0xFFD97706),
        university: 'VIT',
        content: 'Same boat. We keep going.',
        timeAgo: '5m',
        likes: 62,
      ),
    ],
  ),
  Comment(
    id: 'c2',
    username: "MBA'25",
    avatarInitials: 'B',
    avatarColor: const Color(0xFF0891B2),
    university: 'IIM Ahmedabad',
    content: 'Sending strength. The fact that you posted this took courage. Keep going.',
    timeAgo: '22m',
    likes: 391,
    replies: [
      Comment(
        id: 'c2r1',
        username: "ANON",
        avatarInitials: 'A',
        avatarColor: const Color(0xFFEF4444),
        content: 'This comment made my day honestly.',
        timeAgo: '18m',
        likes: 143,
      ),
    ],
  ),
  Comment(
    id: 'c3',
    username: "CIVIL'24",
    avatarInitials: 'V',
    avatarColor: const Color(0xFF374151),
    university: 'IIT Delhi',
    content: 'Been there. It gets better. Not immediately, but it does.',
    timeAgo: '45m',
    likes: 284,
    replies: [],
  ),
  Comment(
    id: 'c4',
    username: "IT'25",
    avatarInitials: 'I',
    avatarColor: const Color(0xFF7C3AED),
    content: 'These are the posts that make this app worth it. Real talk, no filters.',
    timeAgo: '1h',
    likes: 456,
    replies: [
      Comment(
        id: 'c4r1',
        username: "CSE'24",
        avatarInitials: 'C',
        avatarColor: const Color(0xFF059669),
        university: 'BITS Pilani',
        content: 'Exactly why I\'m on here every day.',
        timeAgo: '55m',
        likes: 167,
      ),
    ],
  ),
];

// ── Sample Messages ───────────────────────────────────────────────────────────
final sampleMessages = [
  const Message(id: 'm1', sender: 'Anonymous User', preview: 'Hey, did you see the post about the placement rejections?', timeAgo: '3m ago', isUnread: true, university: 'NIT'),
  const Message(id: 'm2', sender: 'Anonymous User', preview: 'Thanks for the internship tip. Super helpful!', timeAgo: '19m ago', university: 'VIT'),
  const Message(id: 'm3', sender: 'Anonymous User', preview: "You: Let's study together tonight?", timeAgo: '39m ago', university: 'BITS'),
  const Message(id: 'm4', sender: 'Anonymous User', preview: 'Did you read the Campus Secrets post? 👀', timeAgo: 'Yesterday', university: 'IIT'),
  const Message(id: 'm5', sender: 'Anonymous User', preview: 'I totally relate to your post about burnout.', timeAgo: 'Oct 24', university: 'IIIT'),
];