---
title: Dropdown for GitHub workflows input parameters
published: false
description: 'Sometimes when we look at CI/CD tools embedded within git-based software repository manager like GitHub, GitLab or Bitbucket, we ran into a lack of some features.'
tags: 'GitHub, Actions, Dropdown'
canonical_url: 'https://www.arthurbdiniz.com/github/actions/workflows/2021/10/23/gh-action-dropdown.html'
series: GitHub
id: 875888
---

# Dropdown for GitHub workflows input parameters

Sometimes when we look at `CI/CD tools` embedded within git-based software repository manager like `GitHub`, `GitLab` or `Bitbucket`, we ran into a lack of some features.

This time me and my DevOps/SRE team were facing a pain of not being able to have the option to create `drop-downs` within GitHub workflows using input parameters. Although this functionality is already available on other platforms such as Bitbucket, the specific client we were working on stored the code inside GitHub.

At first I thought that someone has already solved this problem somehow, but doing an extensive search on the internet I found several angry GitHub users opening requests within the Support Community and even in the stack overflow.

![comment-1](./assets/comment-1.png)

![comment-2](./assets/comment-2.png)

![comment-3](./assets/comment-3.png)

![comment-5](./assets/comment-5.png)

![comment-4](./assets/comment-4.png)


So I decided to create a solution for this, always thinking about simplicity and in a way that makes it easy to get this missing functionality. I started by creating an input array pattern using `commas` and using a `tag` (the selector) e.g `brackets` as the default value marker. Here is an example of what an input string would look like:

```yml
name: gh-action-dropdown-list-input
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment'
        required: true
        default: 'dev,staging,[uat],prod'
```

Now the final question that would turn out to be the most complicated to deal with. How can I change the GitHub Actions interface to replace the input pattern we created earlier to a dropdown?

The simplest answer I thought was to create a `chrome and firefox extension` that would do all this logic behind the scenes and replace the `HTML input element` with the `selected tag` containing the array values and leaving the tag value (selector) always as the default.

All code was developed in pure JavaScript, open-source licensed under Apache 2.0 and available at https://github.com/arthurbdiniz/gh-action-dropdown-list-input.


## Install extension

- [Chrome](https://chrome.google.com/webstore/detail/github-action-dropdown-in/deogklnblohhopmnkllaeinijefddcnm)

> Firefox: is still in review process to be published.

Once installed, the extension is ready to use and the final result we see is the Actions interface with drop-downs. :)

![showcase-1](./assets/showcase-1.png)

![showcase-2](./assets/showcase-2.png)

### Configuring selectors

Go to the top right corner of the browser you are using and click on the extension logo. A screen will popup with tag options. Choose the right tags for you and save it.

> This action might require reloading the GitHub workflow tab.
![config](./assets/config.png)

---

Have fun using drop-downs inside GitHub. If you liked this project please share this post and if possible "star" within the repository.

Also feel free to connect with me on LinkedIn: https://www.linkedin.com/in/arthurbdiniz


# References

- https://github.community/t/can-workflow-dispatch-input-be-option-list/127338
- https://stackoverflow.com/questions/69296314/dropdown-for-github-workflows-input-parameters
