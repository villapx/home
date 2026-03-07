local requests = require('cmp_ai.requests')

LlamaCpp = requests:new(nil)

function LlamaCpp:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.params = vim.tbl_deep_extend('keep', o, {
    model = 'unknown',
    temperature = 0.1,
    max_tokens = 100,
    url = 'http://127.0.0.1:8080/v1/completions',
  })

  local api_key = self.params.api_key or os.getenv('OPENAI_API_KEY') or 'none'
  self.headers = {
    'Authorization: Bearer ' .. api_key,
  }
  return o
end

function LlamaCpp:complete(lines_before, lines_after, cb)
  local data = {
    model = self.params.model,
    prompt = lines_before,
    suffix = lines_after,
    temperature = self.params.temperature,
    max_tokens = self.params.max_tokens,
    stream = false,
  }

  self:Get(self.params.url, self.headers, data, function(answer)
    local new_data = {}
    if answer.choices then
      for _, response in ipairs(answer.choices) do
        if response.text and response.text ~= '' then
          table.insert(new_data, response.text)
        end
      end
    end
    cb(new_data)
  end)
end

return LlamaCpp
