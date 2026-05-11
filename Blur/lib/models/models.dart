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
  final String? imageUrl;
  final String category;

  const Lounge({
    required this.id,
    required this.name,
    this.university,
    this.members = 0,
    this.posts = 0,
    this.imageUrl,
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

// ── Sample Posts ──────────────────────────────────────────────────────────────
final samplePosts = [
  Post(
    id: '1',
    username: "CSE'24",
    avatarInitials: 'C',
    avatarColor: const Color(0xFF7C3AED),
    university: 'NIT Trichy',
    lounge: 'Memes',
    timeAgo: '12h',
    title: 'When the prof says "this will be in the exam"',
    content: 'POV: It was never in the exam. They lied. Again.',
    likes: 1247,
    comments: 211,
  ),
  Post(
    id: '2',
    username: "MECH'25",
    avatarInitials: 'M',
    avatarColor: const Color(0xFF0891B2),
    university: 'VIT Vellore',
    lounge: 'Academics',
    timeAgo: '1d',
    title: 'How are you all surviving Thermo II?',
    content: 'Honestly considering switching to a non-tech career after this paper. Drop your study resources please 🙏',
    likes: 92,
    comments: 38,
  ),
  Post(
    id: '3',
    username: "CSE'26",
    avatarInitials: 'C',
    avatarColor: const Color(0xFFEF4444),
    university: 'IIIT Hyderabad',
    lounge: 'Confessions',
    timeAgo: '1d',
    title: "I've been pretending to understand DSA for 2 years",
    content: "Placement season is coming. I'm cooked. Send help.",
    likes: 2341,
    comments: 187,
  ),
  Post(
    id: '4',
    username: "MBA'25",
    avatarInitials: 'B',
    avatarColor: const Color(0xFF059669),
    university: 'IIM Bangalore',
    lounge: 'Career',
    timeAgo: '3h',
    title: 'Summer internship prep — what actually matters?',
    content: 'Had 3 PPO interviews this week. Happy to share what worked and what flopped.',
    likes: 456,
    comments: 73,
  ),
  Post(
    id: '5',
    username: "ECE'24",
    avatarInitials: 'E',
    avatarColor: const Color(0xFFD97706),
    university: 'BITS Pilani',
    lounge: 'Rants',
    timeAgo: '6h',
    title: 'Why is campus wifi always down during exams?',
    content: 'Every single semester. Without fail. The timing is criminal at this point.',
    likes: 891,
    comments: 64,
  ),
];

final trendingPosts = [
  Post(
    id: 't1',
    username: "CS'24",
    avatarInitials: 'C',
    avatarColor: const Color(0xFF3B5BDB),
    university: 'Stanford University',
    lounge: 'Career',
    timeAgo: '2h',
    title: 'HIRING SEASON: SWE Internship 2025 Megathread',
    content: "Drop your referrals, prep resources, and interview experiences. Let's help each other.",
    likes: 1560,
    comments: 430,
  ),
  Post(
    id: 't2',
    username: 'ANON',
    avatarInitials: 'A',
    avatarColor: const Color(0xFF7C3AED),
    lounge: 'Rants',
    timeAgo: '4h',
    title: 'Is the dining hall food getting worse?',
    content: 'I swear the quality dropped after the new contractor took over. Anyone else notice?',
    likes: 890,
    comments: 201,
  ),
  Post(
    id: 't3',
    username: "CIVIL'25",
    avatarInitials: 'V',
    avatarColor: const Color(0xFF059669),
    university: 'IIT Bombay',
    lounge: 'Housing',
    timeAgo: '1d',
    title: 'Housing as a Sophomore: Pro-tips',
    content: 'After two semesters off-campus I have things to share. Thread below 👇',
    likes: 710,
    comments: 34,
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
    content: 'This hits different at 2am before the end sem 😭 Same every time.',
    timeAgo: '10m',
    likes: 47,
    replies: [
      Comment(
        id: 'c1r1',
        username: "CSE'26",
        avatarInitials: 'C',
        avatarColor: const Color(0xFF7C3AED),
        content: 'The 2am part is too real 💀',
        timeAgo: '8m',
        likes: 12,
      ),
      Comment(
        id: 'c1r2',
        username: "MECH'24",
        avatarInitials: 'M',
        avatarColor: const Color(0xFFD97706),
        university: 'VIT',
        content: 'We do not miss. We suffer together.',
        timeAgo: '5m',
        likes: 8,
      ),
    ],
  ),
  Comment(
    id: 'c2',
    username: "MBA'25",
    avatarInitials: 'B',
    avatarColor: const Color(0xFF0891B2),
    university: 'IIM Ahmedabad',
    content: 'The collective betrayal when professors say that 😂 No notes. Only pain.',
    timeAgo: '22m',
    likes: 91,
    replies: [
      Comment(
        id: 'c2r1',
        username: 'ANON',
        avatarInitials: 'A',
        avatarColor: const Color(0xFFEF4444),
        content: 'Filing a class action lawsuit against all professors who do this.',
        timeAgo: '18m',
        likes: 203,
      ),
    ],
  ),
  Comment(
    id: 'c3',
    username: "CIVIL'24",
    avatarInitials: 'V',
    avatarColor: const Color(0xFF374151),
    university: 'IIT Delhi',
    content: "I've given up caring. My peace is more important than any exam.",
    timeAgo: '45m',
    likes: 34,
    replies: [],
  ),
  Comment(
    id: 'c4',
    username: "IT'25",
    avatarInitials: 'I',
    avatarColor: const Color(0xFF7C3AED),
    content: 'Study tip: do not study what they say will be in the exam. Study everything else.',
    timeAgo: '1h',
    likes: 156,
    replies: [
      Comment(
        id: 'c4r1',
        username: "CSE'24",
        avatarInitials: 'C',
        avatarColor: const Color(0xFF059669),
        university: 'BITS Pilani',
        content: '5D chess strategy right here 🤣',
        timeAgo: '55m',
        likes: 67,
      ),
    ],
  ),
];

// ── Sample Lounges ────────────────────────────────────────────────────────────
final sampleLounges = [
  const Lounge(id: 'l1', name: 'Pre-med',    university: 'Stanford University', members: 1200, posts: 340, category: 'Academics'),
  const Lounge(id: 'l2', name: 'CS Majors',  university: 'Stanford University', members: 3400, posts: 890, category: 'Academics'),
  const Lounge(id: 'l3', name: 'Greek Life', university: 'Stanford University', members: 800,  posts: 220, category: 'Social'),
  const Lounge(id: 'l4', name: 'Freshman Year', university: 'Stanford University', members: 2100, posts: 670, category: 'Social'),
  const Lounge(id: 'l5', name: 'Stanford Confidential', university: 'Stanford University', members: 5600, posts: 1200, category: 'General'),
];

final sampleMessages = [
  const Message(id: 'm1', sender: 'Anonymous User', preview: 'Hey, did you see the post about the midterm curves?', timeAgo: '3m ago', isUnread: true, university: 'NYU'),
  const Message(id: 'm2', sender: 'Anonymous User', preview: 'Thanks for the info on the internship. Super helpful', timeAgo: '19m ago', university: 'UCLA'),
  const Message(id: 'm3', sender: 'Anonymous User', preview: "You: Let's meet at the library then.", timeAgo: '39m ago', university: 'STAN'),
  const Message(id: 'm4', sender: 'Anonymous User', preview: 'Is the career fair worth it for seniors?', timeAgo: 'Yesterday', university: 'MIT'),
  const Message(id: 'm5', sender: 'Anonymous User', preview: 'I totally agree with your take on the campus housing situation.', timeAgo: 'Oct 24', university: 'BC'),
];