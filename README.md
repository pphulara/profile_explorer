## Profile Explorer

Profile Explorer is a Flutter app that displays random user profiles using the RandomUser API. It demonstrates clean architecture, state management, and synchronization between screens.

## Features

Fetch and display profiles in a grid layout.

Show profile picture, name, age, and city.

Like (heart) button to mark favorite profiles.

Navigate to profile detail screen on image tap.

Sync liked state between home and detail screens.

Handles loading and error states.

## Architecture

Follows Clean Architecture (MVVM) pattern with layers:

data/ – Models, repositories, API services

domain/ – Entities, use cases

presentation/ – UI, viewmodels, widgets

core/ – Common utilities and constants

State management is implemented using Provider.
