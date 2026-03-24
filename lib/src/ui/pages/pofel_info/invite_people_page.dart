import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:share_plus/share_plus.dart';

class InvitePeoplePage extends StatefulWidget {
  const InvitePeoplePage({
    super.key,
    required this.uid,
    required this.pofel,
  });

  final String uid;
  final PofelModel pofel;

  @override
  State<InvitePeoplePage> createState() => _InvitePeoplePageState();
}

class _InvitePeoplePageState extends State<InvitePeoplePage> {
  late final SocialBloc _socialBloc;
  final GlobalKey _shareButtonKey = GlobalKey();

  String get _inviteLink => 'https://pofel.me/?invite=${widget.pofel.joinCode}';

  @override
  void initState() {
    super.initState();
    _socialBloc = SocialBloc()..add(LoadMyFollowing(uid: widget.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _socialBloc,
      child: Scaffold(
        body: PofelScreenBackground(
          showBottomBlobs: false,
          child: SafeArea(
            child: BlocListener<SocialBloc, SocialState>(
              listener: (context, state) {
                if (state is! MyFollowingState) {
                  return;
                }

                switch (state.inviteEnum) {
                  case InviteEnum.INVITED:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pozvánka byla úspěšně poslána'),
                      ),
                    );
                    break;
                  case InviteEnum.FAILED:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBarError(
                        context,
                        'Uživatel tě nesleduje zpátky',
                      ),
                    );
                    break;
                  case InviteEnum.NONE:
                    break;
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InviteHeader(
                      onBack: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: BlocBuilder<SocialBloc, SocialState>(
                        builder: (context, state) {
                          final profiles = state is MyFollowingState ? state.profiles : <ProfileModel>[];

                          return ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _InviteHeroCard(
                                pofel: widget.pofel,
                                inviteLink: _inviteLink,
                                shareButtonKey: _shareButtonKey,
                                onShare: _shareInviteLink,
                                onCopyLink: _copyInviteLink,
                              ),
                              const SizedBox(height: 22),
                              Row(
                                children: [
                                  const Expanded(
                                    child: PofelSectionTitle('Lidi které sleduješ'),
                                  ),
                                  if (state is MyFollowingState) _CountBadge(count: profiles.length),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (state is! MyFollowingState)
                                const _InviteLoadingCard()
                              else if (profiles.isEmpty)
                                const _InviteEmptyCard()
                              else
                                ...profiles.map(
                                  (profile) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _InviteProfileCard(
                                      profile: profile,
                                      onInvite: () {
                                        _socialBloc.add(
                                          InviteUser(
                                            uid: profile.uid,
                                            pofelId: widget.pofel.joinCode,
                                            pofelName: widget.pofel.name,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _copyInviteLink() async {
    await Clipboard.setData(ClipboardData(text: _inviteLink));
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invite link je ve schránce')),
    );
  }

  Future<void> _shareInviteLink() async {
    final shareText = [
      'Právě jsi byl pozván/a/o na epesní pofel ${widget.pofel.name}',
      'Join code: ${widget.pofel.joinCode}',
      'Otevři nebo stáhni appku tady: $_inviteLink',
    ].join('\n');

    try {
      await Share.share(
        shareText,
        subject: widget.pofel.name,
        sharePositionOrigin: _sharePositionOrigin(),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBarError(
          context,
          'Sdílení se nepovedlo. Zkus to prosím znovu.',
        ),
      );
    }
  }

  Rect? _sharePositionOrigin() {
    final shareContext = _shareButtonKey.currentContext;
    final shareRenderObject = shareContext?.findRenderObject();
    if (shareRenderObject is RenderBox) {
      return shareRenderObject.localToGlobal(Offset.zero) & shareRenderObject.size;
    }

    final pageRenderObject = context.findRenderObject();
    if (pageRenderObject is RenderBox) {
      return pageRenderObject.localToGlobal(Offset.zero) & pageRenderObject.size;
    }

    return null;
  }

  @override
  void dispose() {
    _socialBloc.close();
    super.dispose();
  }
}

class _InviteHeader extends StatelessWidget {
  const _InviteHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: PofelPalette.primaryDark,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Pozvat lidi',
            style: GoogleFonts.nunito(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: PofelPalette.text,
            ),
          ),
        ),
      ],
    );
  }
}

class _InviteHeroCard extends StatelessWidget {
  const _InviteHeroCard({
    required this.pofel,
    required this.inviteLink,
    required this.shareButtonKey,
    required this.onShare,
    required this.onCopyLink,
  });

  final PofelModel pofel;
  final String inviteLink;
  final GlobalKey shareButtonKey;
  final VoidCallback onShare;
  final VoidCallback onCopyLink;

  @override
  Widget build(BuildContext context) {
    return PofelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.group_add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pofel.name,
                      style: GoogleFonts.nunito(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Pozvni lidi na tenhle epický pofel',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroStatTile(
                  label: 'Join code',
                  value: pofel.joinCode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroStatTile(
                  label: 'Účastníci',
                  value: pofel.signedUsers.length.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PofelSurfaceCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite link',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: PofelPalette.text.withValues(alpha: 0.62),
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  inviteLink,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: PofelPalette.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  key: shareButtonKey,
                  child: PofelGradientButton(
                    label: 'Sdílet link',
                    icon: Icons.share_rounded,
                    onPressed: onShare,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PofelOutlineButton(
                  label: 'Kopírovat',
                  onPressed: onCopyLink,
                  color: const Color(0xFFFFDCA8),
                  textColor: const Color(0xFF7E4A10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStatTile extends StatelessWidget {
  const _HeroStatTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteProfileCard extends StatelessWidget {
  const _InviteProfileCard({
    required this.profile,
    required this.onInvite,
  });

  final ProfileModel profile;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            foregroundImage: NetworkImage(profile.photo),
            backgroundColor: PofelPalette.softLilac,
            child: Text(
              profile.name.isEmpty ? '?' : profile.name.characters.first.toUpperCase(),
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: PofelPalette.primaryDark,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: PofelPalette.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _SmallInviteButton(onPressed: onInvite),
        ],
      ),
    );
  }
}

class _SmallInviteButton extends StatelessWidget {
  const _SmallInviteButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: PofelPalette.buttonGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: PofelPalette.shadow,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          minimumSize: const Size(104, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        child: const Text('Pozvat'),
      ),
    );
  }
}

class _InviteLoadingCard extends StatelessWidget {
  const _InviteLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const PofelSurfaceCard(
      child: SizedBox(
        height: 160,
        child: Center(
          child: CircularProgressIndicator(
            color: PofelPalette.primary,
          ),
        ),
      ),
    );
  }
}

class _InviteEmptyCard extends StatelessWidget {
  const _InviteEmptyCard();

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: PofelPalette.softLilac,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.person_search_rounded,
              color: PofelPalette.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Zatím tu nikoho nemáš',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: PofelPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: PofelPalette.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w900,
          color: PofelPalette.primary,
        ),
      ),
    );
  }
}
