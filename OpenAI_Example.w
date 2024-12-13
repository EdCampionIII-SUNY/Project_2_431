bring cloud;
bring openai;

// A simple coding assistant that uses OpenAI to generate code snippets
class Assistant {
  programmingLanguage: str;
  openai: openai.OpenAI;

  new(programmingLanguage: str) {
    this.openai = new openai.OpenAI(apiKey: "<your API key here>");
    this.programmingLanguage = programmingLanguage;
  }
  // Passes language and task to prompt
  pub inflight ask(task: str): str {
    let prompt = "You are a coding assistant in the following language: {this.programmingLanguage}. {task}";
    let response = this.openai.createCompletion(prompt);

    return response.trim();
  }
}

// Generates code and stores it in a cloud.Bucket
class Programmer {
  id: cloud.Counter;
  gpt: Assistant;
  store: cloud.Bucket;

  new (store: cloud.Bucket) {
    this.gpt = new Assistant("C");
    this.id = new cloud.Counter() as "NextID";
    this.store = store;
  }

  pub inflight getCode(topic: str): str {
    let reply = this.gpt.ask("Write me a program that: {topic}");
    let n = this.id.inc();
    this.store.put("message-{n}.original.txt", reply);
    return reply;
  }
}

// Translates code received from a `cloud.Topic` and translates them to different programming languages.
// Stores the translated code in a `cloud.Bucket`
class Translator {
  new(language: str, topic: cloud.Topic, store: cloud.Bucket) {
    let gpt = new Assistant("C to ${language} translator.");
    let id = new cloud.Counter() as "NextID";

    topic.onMessage(inflight (original: str) => {
      let n = id.inc();

      log("translating code id {n} to {language}");
      let translated = gpt.ask("Please translate the following code: {original}");
      
      store.put("{language}/message-{n}.translated.txt", translated);
      log("written code id {n} in {language}");
    });
  }
}

// Pre-flight code to generate the bucket, the topic, the programmer, and the translators
let store = new cloud.Bucket() as "Code Store";
let newCodeSource = new cloud.Topic() as "New Code";

let programmer = new Programmer(store) as "Programmer";

new Translator("Python", newCodeSource, store) as "Python Translator";
new Translator("Java", newCodeSource, store) as "Java Translator";
new Translator("C++", newCodeSource, store) as "C++ Translator";

// The main inflight function that generates code and publishes it to the topic
new cloud.Function(inflight () => {
  let topic = "programming languages";
  log("requesting a program that ${topic}");
  let code = programmer.getCode(topic);
  log("publishing code: ${code}");
  newCodeSource.publish(code);
}) as "START HERE";