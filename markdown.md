name: inverse
layout: true
class: center, middle, inverse
---
# Unique Versioning with .fa[.fa-git-square[]].

.footnote[.pull-right[![odecee icon](http://odecee.com.au/wp-content/themes/odecee/library/images/logo-white.svg)]]
---
layout:false
class: center, middle, inverse

## Who am I?
.right[
### Chao Luan
.pull-right[![Gravatar](https://s.gravatar.com/avatar/53fe10fa1ac0c9073119e7227647f69f?s=80)]

Lead DevOps Engineer @ Odecee

.fa[.fa-github[]] mistaka0s | .fa[.fa-linkedin-square[]] chao.luan
]

---
class: middle

.left-column[
Who am I?
]
.right-column[.middle[
- 15 years in IT, working in consultancies.
- Systems Admin background
- Middleware/Build Engineer ~ 2009
- Systems automation since 2010.
- Building platforms since then.
]]

---
class: center, middle, inverse
# Agenda
---
class: middle

.left-column[
Agenda
]
.right-column[
1. Why Version
2. Common versioning strategies.
3. Git Tags
4. Unique versioning
5. Demo
6. Applications and things you need to consider.
]

---
class: center, middle, inverse
# Why version your artifacts?

---
class: middle

.left-column[
Why Version?
]

.right-column[
The reasons why you should version your code releases are many.

* Release management
* A way of describing the maturity of your code
* Use it to manage depenedencies.
* Produce artifacts
* Auditability
* Debug
]
--
count: false
.right-column[
* .red[ Be reproducible]
* .red[ Be able to trace back the release of an artifact back to source code ]

If you aren't versioning your code, you really should be.
]

---
class: center, middle, inverse
# Common versioning strategies
---
class: middle
name: how
.left-column[
Versioning Strategies
]

.right-column[
Over the past years, I've seen many ways of versioning but none I feel are better than `semantic versioning` (`semver`).

These seem to arise from being able to build unique versions of artifacts for CI implementations and while they solve some problems of versioning, it also causes other problems.

Things I've seen out in the wild are:

- Date/Time versioning - version `201704211049`
- Build # derived versioning - version `build#`
- Semver, but controled by CI tool - `1.2.4`

]

---
class: middle
name: how
.left-column[
Date/Time versioning
]

.right-column[
Take the date and time that you've built the artifact & use it as a unqiue version

*Pros:*
- Easy to generate .green[.fa[.fa-check-circle[]]]
```shell
$ date "+%Y%m%d%H%M%S"
20170421153012
```
- Easy to compare (computationally) .green[.fa[.fa-check-circle[]]]
```python
>>> 20170421153359 > 20170421153012
True
```
-  (almost) Unique version.green[.fa[.fa-check-circle[]]]

]

---
class: middle
name: how
.left-column[
Date/Time versioning
]

.right-column[
Take the date and time that you've built the artifact & use it as a unqiue version

*Cons:*

- Hard to read and interpret: .red[.fa[.fa-minus-circle[]]]
```bash
20170423153359
20170424153946
20170421153012
20170514153946
20170424153946
```

- Auditablity: No easily derived information on build or source .red[.fa[.fa-minus-circle[]]]

- Maturity of code: Can you easily tell whether this was built off a stable release branch or an untested branch?

- Repeatability .red[.fa[.fa-minus-circle[]]]
]

???
Hard to read:
- At a glance, which is the most recent version?
- What timezone was it generated in?

Repeatability:
- Have to force the date somehow, but if you do that, you make the system less trustworthy.

---
class: middle
name: how
.left-column[
Build versions from CI.
]

.right-column[
Usually versioned by taking something then appending the build number at the end.

`<arbitrary version>-<build-number>`


Examples:
```
HelloWorld-42
App-#210
```

*Pros:*
- Easy to trace back to a build .green[.fa[.fa-check-circle[]]]

- Easy to generate .green[.fa[.fa-check-circle[]]]

- Unique version .green[.fa[.fa-check-circle[]]]
]

???
Easy to trace back to a build:
- If you know how the identify the build.

Easy to generate:
- CI tool will always increment the build number by 1

---
class: middle
name: how
.left-column[
Build versions from CI.
]
Usually versioned by taking something then appending the build number at the end.

`<arbitrary version>-<build-number>`

.right-column[

*Cons:*
- Versioning is tied to the build server .red[.fa[.fa-minus-circle[]]]

- What if it's down? .red[.fa[.fa-minus-circle[]]]

- Concepts of code maturity isn't there .red[.fa[.fa-minus-circle[]]]

- Have to refer to the build to find the source .red[.fa[.fa-minus-circle[]]]

- Very hard to rebuild the same version. .red[.fa[.fa-minus-circle[]]]

]

???
What if it's down?
- How do you build and maintain versions?

Concepts of code maturity isn't there:
- How do you account for feature builds?


---
class: middle
name: how
.left-column[
Semantic Versioning from CI
]

.right-column[
Has the same `pros` and `cons` with the build numbers in CI.

But:
- requires the developer or build engineer to maintain the build

- logic and semantic versioning within the build tool.

Compounded by:
- having multiple release branches

- when feature builds are built as well.

]

---
class: center, middle, inverse
# What's wrong with these versioning strategies?

---

class: middle
name: how
.left-column[
What's wrong with these strategies?
]

.right-column[
The problem?

- They're trying to be source of truth for versioning with no real interaction with SCM.

- Build tools are usually not flexible enough and try to be too many things.

- CI tool is another place where developers need to touch.

- The version is not derived from source code and so extra logic and state must be maintained with the build tool.
]

---
class: center, middle, inverse
# Versioning with .fa[.fa-git-square[]].

---

class: middle
name: how
.left-column[
Versioning with GIT.
]

.right-column[
With `git` every commit you make generates a unique SHA.

```
*commit 10c5d8750aa2745582d3065c9e5da3de5a6ac4b6
Author: Chao Luan <mistaka0s@users.noreply.github.com>
Date:   Tue Apr 25 21:45:38 2017 +1000

    Latest version
```

The commit SHA is commonly shortened to 8 characters:
`10c5d875` is equivalent to `10c5d8750aa2745582d3065c9e5da3de5a6ac4b6`

But don't do this: `<version>.<git_sha>`

You can't tell which version is later.
```
0.1.62d0491
0.1.63cc0cd
0.1.1280e0a
0.1.aae79fc
0.1.38a942c
0.1.97cc06c
0.1.2a34c52
0.1.894fe7a
```
]

???
SHAs in example are actually commits in order (latest first)

---
class: center, middle, inverse
# Leverage Git tags instead

---
class: middle
name: why
.left-column[
Leverage Git Tags
]

.right-column[
You can `tag` a commit within git and give it a more friendly to read name.

Think about it as a symlink or alias to an actual commit SHA.

```
$  git tag -l
0.0.1
0.1.0
0.1.1
0.1.10
0.1.11
0.1.12
0.1.2
0.1.3
0.1.4
0.1.5
0.1.6
0.1.7
0.1.8
0.1.9
```


]

---
class: center, middle, inverse
# Does that mean you have to tag every commit?

---
class: middle
name: why
.left-column[
Tag every commit?
]

.right-column[
No, definitely not.

Use `git describe --tags`!

> The command `finds the most recent tag` that is reachable from a commit. `If the tag points to the commit, then only the tag is shown`. Otherwise, it suffixes the `tag name with the number of additional commits on top of the tagged object` and the `abbreviated object name of the most recent commit`.


TL;DR:

If on a `tag`, return `tag`.

If not, return `<tagz.`-`# commits`-g`SHA`

]
