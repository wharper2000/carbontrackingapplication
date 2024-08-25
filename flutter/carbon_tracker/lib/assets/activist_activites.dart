import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/linecons_icons.dart';

enum ActivistActivites {
  extinctionrebellion,
  juststopoil,
  greenpeace,
  friendsoftheearth,
}

Map<ActivistActivites, String> ActivistActivitesNames = {
  ActivistActivites.extinctionrebellion: 'Extinction Rebellion',
  ActivistActivites.juststopoil: 'Just Stop Oil',
  ActivistActivites.greenpeace: 'Green Peace',
  ActivistActivites.friendsoftheearth: 'Friends Of The Earth',
};

Map<ActivistActivites, String> ActivistActivitesUrl = {
  ActivistActivites.extinctionrebellion:
      'https://extinctionrebellion.uk/join-us/',
  ActivistActivites.juststopoil: 'https://juststopoil.org/',
  ActivistActivites.greenpeace: 'https://www.greenpeace.org.uk/',
  ActivistActivites.friendsoftheearth: 'https://friendsoftheearth.uk/',
};

Map<ActivistActivites, String> ActivistActivitesDescriptions = {
  ActivistActivites.extinctionrebellion:
      'We are a network of people who care deeply about the future of our planet, all human beings, and all living things. We are from diverse backgrounds and experiences – but come together in Extinction Rebellion because we are living in a time of Climate and Nature Emergency and want to contribute, in our various ways, to making things better.',
  ActivistActivites.juststopoil: 'We have a new Government and they have committed to enacting Just Stop Oil’s original demand for no new oil, gas or coal projects. This is a welcome step in the right direction, but the science is abundantly clear that this is not enough to protect our families and communities from the worst effects of climate breakdown. That’s why Just Stop Oil will be acting with other groups internationally, taking action at sites of key importance to the fossil fuel economy, in order to demand our governments commit to a legally binding international treaty to end the extraction and burning of oil gas and coal by 2030.',
  ActivistActivites.greenpeace: 'Greenpeace campaigns are changing the world for the better. From saving the whales to getting rid of polluting cars, our victories are powered by individual donations, dedicated volunteers and millions of supporters.',
  ActivistActivites.friendsoftheearth: "Friends of the Earth is a leading environmental organisation working to create a sustainable future. We fight for climate justice through grassroots campaigns and legal action. Whether that's using the law to stop fossil fuel projects, or pushing for greater rights to protect nature and our environment. ",
};
