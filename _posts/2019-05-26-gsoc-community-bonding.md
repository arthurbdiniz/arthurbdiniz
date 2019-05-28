---
layout: post
title:  "GSoC Community Bonding Experience"
date:   2019-05-27
desc: "Following the approval of Google Summer of Code], a community bounding period begins where students from each organization spend a period from May 6 to May 27, 2019, knowing more about their organization."
keywords: "GSoC,Experience,Communiy,debian"
categories: [HTML]
tags: [GSoC,Communiy]
icon: icon-html
---

Following the approval of [Google Summer of Code](https://summerofcode.withgoogle.com/) as the student selected on the development of the [Cloud Image Finder](), a web application that will make it easier for users to find official Debian cloud images, with `Lucas Kanashiro` and `Bastian Blank` as mentors.

A [community bounding](https://summerofcode.withgoogle.com/how-it-works/#timeline) period begins where students from each organization spend a period from `May 6 to May 27, 2019`, knowing more about their organization.

That way I would like to document my experience with Debian during this time.

In the first week talking to my mentor `Lucas Kanashiro`, i started my communication with the IRC channels where I saw that the community is very active and collaborative, I had some problems to keep myself active as IRC because of the firewall of my university and I ended up going to a cloud solution of IRC, where at the moment i am using the free client [alwyzon](https://beta.alwyzon.com). About my channel communication, as soon as I joined the #debian-cloud channel i was very happy and felt embraced by the community inside the project, seeing people willing to help in what is necessary and always giving me feedbacks.

Another way of communication that I found to be very important are [mailing lists](https://lists.debian.org/completeindex.html) in which all content is stored in Debian`s infrastructure and has greater visibility.

That way I learned two things, if you just want to take a quick question or talk and that are very specific problems, IRC channels will help you, in the case of notify the community and leave it saved you should go to  mailing list.

At the end of community bonding I was already to send and reply to emails and using IRC to communicate and in order to elicitate project requirements we use the `prototyping technique`. We started from a [Low Fidelity Prototype](https://salsa.debian.org/cloud-team/image-finder/wikis/Low-Fidelity-Prototype), which was used to validate basic concepts and also gather some feedback from the Cloud Team. After an evaluation we came up with a [High Fidelity Prototype](https://salsa.debian.org/cloud-team/image-finder/wikis/High-Fidelity-Prototype), where we applied the required modifications raised in the last step. All of this has been documented in [issues](https://salsa.debian.org/cloud-team/image-finder/issues) within our [repository](https://salsa.debian.org/cloud-team/image-finder) and [wiki](https://salsa.debian.org/cloud-team/image-finder/wikis).


Finally last week I had a meeting with my mentor Lucas Kanashiro where we discussed about the features prioritization based on cloud team feedback over low-fidelity prototype, where this meeting resulted in making some decisions before starting the coding phase.

We noticed the necessity to perform some steps prior starting the code phase. The first one is to design the database schema based on the output artifacts in the [build](https://salsa.debian.org/cloud-team/debian-cloud-images/pipelines) of the cloud images we would model our database.

Cloud Image Finder Next Steps:

- [Database Schema](https://salsa.debian.org/cloud-team/image-finder/wikis/Database-Schema)
- Architecture Diagram
- Start Code