# Welcome 

This repo contains my personal tools for AI engineering (or better said gardening). Throughout the process they might be shared with my company and from then on with the whole worlds, lets see how far it goes. 

The new age of programming isnt ... programming. Its probably not even engineering. Code writing is not just cheap, its as far as gone for us humans. With the help of Ace you are a new type of engineer. You don't engineer the code, you engineer the factory and give inputs to that factory. 

# What is Ace? 

Ace is not just a bunch of skills. Its a bit more. Its an agentic system. Use the `ace-setup` skill to setup your project. Ace contains the following: 

- a core skills (also called the cycle), thats the factory
- extension packs (understanding pack, simpliness pack)

# Personal skills vs project skills 

Reviewing or auditors are project level...

# Cloud vs not cloud

Some things will run in the cloud, some things will run on your local machine. I personally guess more and more we will move to the cloud. However the system here is not build for one specific type of machine. At the end something running in the cloud can access your app the same way if you set everything up correctly. 

# Skills 

A skill can be two things. Either something the coding sees and uses, or something you, as the user, know and want to actively use. 

In both cases its just context handed to the agent.

Not everything needs to be a skill. If neither of the two upper cases apply, it shouldn't be a skill, it's just an instruction or knowledge a skill points to. 

# The cycle 

You can call it a factory. You can call it restaurant. You can call it a garden. Many terms match. I call it a cycle, because that's what it is. Software is in 99% of the cases never done. 

The cycle is a loop. It starts with an idea that forms into a plan. The plan gets implemented. The code gets verified, tested and reviewed. This is inner loop.. 

### Stage 1: Ideation + Planning

- a cron auditor finding a bug 
- a human doing a grilling session about a feature they want to be implemented. 
- a error log reporting a bug

The router skill for that stage is `/skills/ace-1`

### Stage 2: Implementation & Verifications & Testing

The router skill for that stage is `/skills/ace-2`

### Stage 3: Review + Iteration 

The router skill for that stage is `/skills/ace-3`

### Stage 4: Retrospection + Adaption

The router skill for that stage is `/skills/ace-4`

# Additional tools 

### Understanding & Learning 

Core of the new role of an engineer is to understand the architecture. You shouldn't generate code, you're not able to understand. That doesn't mean you need to understand your whole codebase.

# Personalization

Ace is generic. Its suitable for all sorts of software projects in whatever language. What matters is the customization to your needs. 

NEVER CHANGE SKILLS FROM ACE. 

The skills are built in a way that they listen to your needs. These customizers live in `ace/` in your project, and `ace-setup` creates them: 

- `GLOSSARY.md` holds a shared language between the human and the agent, so that nothing drifts. 
- `AGENTS.md` gets injected into every agent session. Tell the agent what your app is, how it works and how your code is structured, so it finds things more efficiently.
- `CODING_STANDARDS.md` gets used in stage 2 and 3. To check that the code is written in a way that is consistent with your coding standards.
- `TICKET_TRACKER.md` says how to read, search, open, and update tickets, e.g. in GitHub Issues, Linear, Jira, etc.
- `CODE_HOSTING.md` says how to open a pull request and find the tickets it closes, e.g. on Github, Gitlab, Bitbucket, etc.

# TODO

- where does verification fit in? 
- where does testing fit in? 
- idea: abstract away skills fully?