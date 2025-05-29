---
layout: post
title: "Bringing Kubernetes Back to Debian"
date: 2025-05-29
desc: "The Journey of Repackaging and Reviving the Ecosystem"
keywords: ""
tags: [Kubernetes]
---

I've been part of the Debian Project since 2019, when I attended DebConf held in Curitiba, Brazil. That event sparked my interest in the community, packaging, and how Debian works as a distribution.

In the early years of my involvement, I contributed to various teams such as the `Python`, `Golang` and `Cloud` teams, packaging dependencies and maintaining various tools. However, I soon felt the need to focus on packaging software I truly enjoyed, tools I was passionate about using and maintaining.

That's when I turned my attention to **Kubernetes within Debian**.

---


## A Broken Ecosystem

The Kubernetes packaging situation in Debian had been problematic for some time. Given its large codebase and complex dependency tree, the initial packaging approach involved vendorizing all dependencies. While this allowed a somewhat functional package to be published, it introduced several long-term issues, especially security concerns.

Vendorized packages bundle third-party dependencies directly into the source tarball. When vulnerabilities arise in those dependencies, it becomes difficult for Debian's security team to patch and rebuild affected packages system-wide. This approach broke Debian's best practices, and it eventually led to the abandonment of the Kubernetes source package, which had stalled at version `1.20.5`.

Due to this abandonment, critical bugs emerged and the package was removed from Debian's testing channel, as we can see in the [package tracker](https://tracker.debian.org/news/1315335/kubernetes-removed-from-testing/).

---

## New Debian Kubernetes Team

Around this time, I became a **Debian Maintainer (DM)**, with permissions to upload certain packages. I saw an opportunity to both contribute more deeply to Debian and to fix Kubernetes packaging.

In early 2024, just before DebConf Busan in South Korea, I founded the [Debian Kubernetes Team](https://salsa.debian.org/kubernetes-team). The mission of the team was to repackage Kubernetes in a maintainable, security-conscious, and Debian-compliant way. At DebConf, I [shared our progress](https://debconf24.debconf.org/talks/47-exploring-kubernetes-in-debian-a-call-to-support/) with the broader community and received great feedback and more visibility, along with people interested in contributing to the team.

Our first tasks was to migrate existing Kubernetes-related tools such as `kubectx`, `kubernetes-split-yaml` and `kubetail` into a dedicated [namespace](https://salsa.debian.org/kubernetes-team/packages) on Salsa, Debian's GitLab instance.

Many of these tools were stored across different teams (like the Go team), and consolidating them helped us organize development and focus our efforts.

---

## De-vendorizing Kubernetes

Our main goal was to un-vendorize Kubernetes and bring it up-to-date with upstream releases.

This meant:

- Removing the vendor directory and all embedded third-party code.
- Trimming the build scope to focus solely on building `kubectl`, Kubernetes' CLI.
- Using `Files-Excluded` in `debian/copyright` to cleanly drop unneeded files during source imports.
- Rebuilding the dependency tree, ensuring all Go modules were separately packaged in Debian.

We used `uscan`, a standard Debian packaging tool that fetches upstream tarballs and prepares them accordingly. The `Files-Excluded` directive in our `debian/copyright` file instructed `uscan` to automatically remove unnecessary files during the repackaging process:

```shell
$ uscan
Newest version of kubernetes on remote site is 1.32.3, specified download version is 1.32.3
Successfully repacked ../v1.32.3 as ../kubernetes_1.32.3+ds.orig.tar.gz, deleting 30616 files from it.
```

The results were dramatic. By comparing the original upstream tarball with our repackaged version, we can see that our approach reduced the tarball size by over `75%`:

```shell
$ du -h upstream-v1.32.3.tar.gz kubernetes_1.32.3+ds.orig.tar.gz
14M	upstream-v1.32.3.tar.gz
3.2M	kubernetes_1.32.3+ds.orig.tar.gz
```

This significant reduction wasn't just about saving space. By removing over `30,000` files, we simplified the package, making it more maintainable. Each dependency could now be properly tracked, updated, and patched independently, resolving the security concerns that had plagued the previous packaging approach.

---

## Dependency Graph

To give you an idea of the complexity involved in packaging Kubernetes for Debian, the image below is a dependency graph generated with `debtree`, visualizing all the Go modules and other dependencies required to build the `kubectl` binary.

![kubectl-depgraph]({{ site.img_path }}/bringing-kubernetes-back-to-debian/kubectl-depgraph.jpg){:height="600px" :width="100%"}

This web of nodes and edges represents every module and its relationship during the compilation process of `kubectl`. Each box is a Debian package, and the lines connecting them show how deeply intertwined the ecosystem is. What might look like a mess of blue spaghetti is actually a clear demonstration of the vast and interconnected upstream world that tools like kubectl rely on.

But more importantly, this graph is a testament to the effort that went into making kubectl build entirely using Debian-packaged dependencies only, no vendoring, no downloading from the internet, no proprietary blobs.

---

## Upstream Version 1.32.3 and Beyond

After nearly two years of work, we successfully uploaded version `1.32.3+ds` of `kubectl` to Debian unstable.

[kubernetes/-/merge_requests/1](https://salsa.debian.org/kubernetes-team/packages/kubernetes/-/merge_requests/1)

- Closed over a dozen long-standing bugs, including:
  - Outdated version requests
  - Missing shell completions
  - VCS (version control system) metadata issues
  - ([#1055411](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1055411), [#990793](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=990793), [#1009356](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1009356), [#1016441](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1016441), [#1086756](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1086756), [#1047881](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1047881), [#832706](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=832706), [#976428](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=976428), [#994438](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=994438))

The new package also includes:

- `Zsh`, `Fish`, and `Bash completions` installed automatically
- `Man pages` and metadata for improved discoverability
- Full integration with `kind` and `docker` for testing purposes

---

## Integration Testing with Autopkgtest

To ensure the reliability of kubectl in real-world scenarios, we developed a new [autopkgtest](https://manpages.debian.org/testing/autopkgtest/autopkgtest.1.en.html) suite that runs integration tests using real Kubernetes clusters created via [Kind](https://kind.sigs.k8s.io/).

Autopkgtest is a Debian tool used to run automated tests on binary packages. These tests are executed after the package is built but before it’s accepted into the Debian archive, helping catch regressions and integration issues early in the packaging pipeline.

Our test workflow validates kubectl by performing the following steps:
  - Installing Kind and Docker as test dependencies.
  - Spinning up two local Kubernetes clusters.
  - Switching between cluster contexts to ensure multi-cluster support.
  - Deploying and scaling a sample nginx application using kubectl.
  - Cleaning up the entire test environment to avoid side effects.

- [debian/tests/kubectl.sh](https://salsa.debian.org/kubernetes-team/packages/kubernetes/-/blob/debian/sid/debian/tests/kubectl.sh)

---

## Popcon: Measuring Adoption

To measure real-world usage, we rely on data from Debian's **popularity contest (popcon)**, which gives insight into how many users have each binary installed.

![popcon-graph]({{ site.img_path }}/bringing-kubernetes-back-to-debian/popcon-graph.png){:height="500px" :width="100%"}
![popcon-table]({{ site.img_path }}/bringing-kubernetes-back-to-debian/popcon-table.png){:height="200px" :width="100%"}

Here's what the data tells us:

- `kubectl (new binary)`:  Already installed on **2,124** systems.
- `golang-k8s-kubectl-dev`: This is the Go development package (a library), useful for other packages and developers who want to interact with Kubernetes programmatically.
- `kubernetes-client`: The legacy package that kubectl is replacing. We expect this number to decrease in future releases as more systems transition to the new package.

Although the popcon data shows activity for kubectl before the official Debian upload date, it’s important to note that those numbers represent users who had it installed from upstream source-lists, not from the Debian repositories. This distinction underscores a demand that existed even before the package was available in Debian proper, and it validates the importance of bringing it into the archive.

> Also worth mentioning: this number is not the real total number of installations, since users can choose not to participate in the popularity contest. So the actual adoption is likely higher than what popcon reflects.

---

## Community and Documentation

The team also maintains a dedicated wiki page which documents:

- Maintained tools and packages
- Contribution guidelines
- Our roadmap for the upcoming Debian releases

[https://debian-kubernetes.org](https://debian-kubernetes.org)

---

## Looking Ahead to Debian 13 (Trixie)

The next stable release of Debian will ship with `kubectl version 1.32.3`, built from a clean, de-vendorized source. This version includes nearly all the latest upstream features, and will be the first time in years that Debian users can rely on an up-to-date, policy-compliant kubectl directly from the archive.

By comparing with upstream, our Debian package even delivers more out of the box, including `shell completions`, which the upstream still requires users to generate manually.

In 2025, the Debian Kubernetes team will continue expanding our packaging efforts for the Kubernetes ecosystem.

Our roadmap includes:

- **kubelet**: The primary node agent that runs on each node. This will enable Debian users to create fully functional Kubernetes nodes without relying on external packages.

- **kubeadm**: A tool for creating Kubernetes clusters. With `kubeadm` in Debian, users will then be able to bootstrap minimum viable clusters directly from the official repositories.

- **helm**: The package manager for Kubernetes that helps manage applications through Kubernetes YAML files defined as charts.

- **kompose**: A conversion tool that helps users familiar with docker-compose move to Kubernetes by translating Docker Compose files into Kubernetes resources.

---

## Final Thoughts

This journey was only possible thanks to the amazing support of the [debian-devel-br](https://debianbrasil.org.br) community and the collective effort of contributors who stepped up to package missing dependencies, fix bugs, and test new versions.

Special thanks to:
- Carlos Henrique Melara (@charles)
- Guilherme Puida (@puida)
- João Pedro Nobrega  (@jnpf)
- Lucas Kanashiro (@kanashiro)
- Matheus Polkorny (@polkorny)
- Samuel Henrique (@samueloph)
- Sergio Cipriano (@cipriano)
- Sergio Durigan Junior (@sergiodj)

I look forward to continuing this work, bringing more Kubernetes tools into Debian and improving the developer experience for everyone.
